#!/usr/bin/env bash
set -o xtrace

BOOKINFO_NAMESPACE=bookinfo
AM_NAMESPACE=istio-system

if [[ $1 = "install" ]]; then
	kubectl apply -f ./namespace.yaml || true
	kubectl -n ${BOOKINFO_NAMESPACE} apply -f ./deploy
	kubectl -n ${AM_NAMESPACE} apply -f ./envoyfilter
	sleep 2
  kubectl -n ${BOOKINFO_NAMESPACE} wait --timeout=2m --for=condition=Ready pods --all
  exit 0
fi

if [[ $1 = "uninstall" ]]; then
	kubectl -n ${AM_NAMESPACE} delete -f ./envoyfilter
	kubectl -n ${BOOKINFO_NAMESPACE} delete -f ./deploy
	kubectl delete namespace ${BOOKINFO_NAMESPACE}
  exit 0
fi

if [[ $1 = "info" ]]; then
	kubectl -n ${BOOKINFO_NAMESPACE} get all -o wide
  exit 0
fi

if [[ $1 = "restart" ]]; then
	kubectl -n ${BOOKINFO_NAMESPACE} rollout restart deployments
	kubectl -n ${BOOKINFO_NAMESPACE} wait --timeout=2m --for=condition=Ready pods --all
  exit 0
fi

echo "please specify action ./bookinfo.sh install/update/info/restart"
exit 1
