#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)
ISTIO_VERSION=1.9.8
AM_VERSION=${ISTIO_VERSION}-am1

AM_DIR=${ROOT_DIR}/aspenmesh/aspenmesh-${AM_VERSION}
AM_HELM_CHART_DIR=${AM_DIR}/manifests/charts
AM_NAMESPACE=istio-system
AM_CERT_DIR=${ROOT_DIR}/udf/certs
AM_SVC_DIR=${ROOT_DIR}/udf/aspenmesh/services
AM_VALUES=${ROOT_DIR}/udf/aspenmesh/demo-values.yaml


if [[ $1 = "install" ]]; then
  kubectl create ns ${AM_NAMESPACE}
  kubectl create secret generic cacerts -n ${AM_NAMESPACE} \
    --from-file=${AM_CERT_DIR}/demo/ca-cert.pem \
    --from-file=${AM_CERT_DIR}/demo/ca-key.pem \
    --from-file=${AM_CERT_DIR}/demo/root-cert.pem \
    --from-file=${AM_CERT_DIR}/demo/cert-chain.pem
  helm install istio-base ${AM_HELM_CHART_DIR}/base --namespace ${AM_NAMESPACE}
  helm install istiod ${AM_HELM_CHART_DIR}/istio-control/istio-discovery --namespace ${AM_NAMESPACE} --values ${AM_VALUES}
  helm install istio-ingress ${AM_HELM_CHART_DIR}/gateways/istio-ingress --namespace ${AM_NAMESPACE} --values ${AM_VALUES}
  helm install istio-egress ${AM_HELM_CHART_DIR}/gateways/istio-egress --namespace ${AM_NAMESPACE} --values ${AM_VALUES}
  kubectl wait --timeout=5m --for=condition=Ready pods --all -n ${AM_NAMESPACE}
  exit 0
fi

if [[ $1 = "update" ]]; then
  helm upgrade istio-base ${AM_HELM_CHART_DIR}/base --namespace ${AM_NAMESPACE} || true
  helm upgrade istiod ${AM_HELM_CHART_DIR}/istio-control/istio-discovery --namespace ${AM_NAMESPACE} --values ${AM_VALUES} || true
  helm upgrade istio-ingress ${AM_HELM_CHART_DIR}/gateways/istio-ingress --namespace ${AM_NAMESPACE} --values ${AM_VALUES} || true
  helm upgrade istio-egress ${AM_HELM_CHART_DIR}/gateways/istio-egress --namespace ${AM_NAMESPACE} --values ${AM_VALUES} || true
  kubectl wait --timeout=5m --for=condition=Ready pods --all -n ${AM_NAMESPACE}
  exit 0
fi

if [[ $1 = "remove" ]]; then
  helm uninstall istio-egress --namespace ${AM_NAMESPACE} || true
  helm uninstall istio-ingress --namespace ${AM_NAMESPACE} || true
  helm uninstall istiod --namespace ${AM_NAMESPACE} || true
  helm uninstall istio-base --namespace ${AM_NAMESPACE} || true
  kubectl delete ns ${AM_NAMESPACE} || true
  exit 0
fi

if [[ $1 = "istioctl" ]]; then
  curl -sL https://istio.io/downloadIstioctl | ISTIO_VERSION=${ISTIO_VERSION} sh - && \
  sudo cp ~/.istioctl/bin/istioctl /usr/local/bin
  exit 0
fi

if [[ $1 = "services" ]]; then
  kubectl apply -f ${AM_SVC_DIR}
  exit 0
fi

echo "please specify action ./aspenmesh.sh install/update/remove/istioctl/services"
exit 1
