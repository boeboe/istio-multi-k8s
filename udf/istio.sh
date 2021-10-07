#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)
ISTIO_VERSION=1.11.3

if [[ $1 = "istioctl" ]]; then
  curl -sL https://istio.io/downloadIstioctl | ISTIO_VERSION=${ISTIO_VERSION} sh - && \
  sudo cp ~/.istioctl/bin/istioctl /usr/local/bin
  exit 0
fi

echo "please specify action ./istio.sh istioctl"
exit 1