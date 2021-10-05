#!/usr/bin/env bash
set -o xtrace

FORTIO_NAMESPACE=fortio
AM_NAMESPACE=istio-system

if [[ $1 = "install" ]]; then
	kubectl apply -f ./namespace.yaml || true
	kubectl -n ${FORTIO_NAMESPACE} apply -f ./deploy
	kubectl -n ${AM_NAMESPACE} apply -f ./envoyfilter
	sleep 2
  kubectl -n ${FORTIO_NAMESPACE} wait --timeout=2m --for=condition=Ready pods --all
  exit 0
fi

if [[ $1 = "uninstall" ]]; then
	kubectl -n ${AM_NAMESPACE} delete -f ./envoyfilter
	kubectl -n ${FORTIO_NAMESPACE} delete -f ./deploy
	kubectl delete namespace ${FORTIO_NAMESPACE}
  exit 0
fi

if [[ $1 = "info" ]]; then
	kubectl -n ${FORTIO_NAMESPACE} get all -o wide
  exit 0
fi

if [[ $1 = "restart" ]]; then
	kubectl -n ${FORTIO_NAMESPACE} rollout restart deployments
	kubectl -n ${FORTIO_NAMESPACE} wait --timeout=2m --for=condition=Ready pods --all
  exit 0
fi

if [[ $1 = "check_endpoints" ]]; then
	istioctl -n ${FORTIO_NAMESPACE} proxy-config endpoint $(kubectl -n ${FORTIO_NAMESPACE} get pod -l app=fortio-client -o jsonpath='{.items[0].metadata.name}') | grep fortio-server
  exit 0
fi

if [[ $1 = "test_traffic" ]]; then
	for CON in 4 8 12 16 20 24 28 32; do
		echo "Number of client concurrent connections: ${CON}"
		kubectl -n ${FORTIO_NAMESPACE} exec -it $(kubectl -n ${FORTIO_NAMESPACE} get pods -l app=fortio-client --output=jsonpath='{.items..metadata.name}') -c fortio -- /usr/bin/fortio load -jitter=true -c=${CON} -qps=1000 -t=30s -a -r=0.001 http://fortio-server:8080/echo\?size\=512 | grep "All done"
	done
  exit 0
fi

if [[ $1 = "test_traffic_infinite" ]]; then
	kubectl -n ${FORTIO_NAMESPACE} exec -it $(kubectl -n ${FORTIO_NAMESPACE} get pods -l app=fortio-client --output=jsonpath='{.items..metadata.name}') -c fortio -- /usr/bin/fortio load -jitter=true -c=8 -qps=1000 -t=0 -a -r=0.001 http://fortio-server:8080/echo\?size\=512
  exit 0
fi

if [[ $1 = "delete_server" ]]; then
	kubectl -n ${FORTIO_NAMESPACE} delete pod --force --grace-period=0  $(kubectl -n ${FORTIO_NAMESPACE} get pod -l app=fortio-server -o jsonpath='{.items[0].metadata.name}')
  exit 0
fi

if [[ $1 = "scale_up_server" ]]; then
	kubectl -n ${FORTIO_NAMESPACE} scale deploy fortio-server --replicas=1
  exit 0
fi

if [[ $1 = "scale_down_server" ]]; then
	kubectl -n ${FORTIO_NAMESPACE} scale deploy fortio-server --replicas=0
  exit 0
fi


echo "please specify action ./fortio.sh install/update/info/restart/check_endpoints/test_traffic/test_traffic_infinite/delete_server/scale_up_server/scale_down_server"
exit 1
