#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)

HOME_DIR=/home/ubuntu
REPO_DIR=${HOME_DIR}/udf-istio-multi-k8s
CONF_DIR=${REPO_DIR}/udf/codeserver

if [[ $1 = "install" ]]; then
  curl -fsSL https://code-server.dev/install.sh | sh
  cp ${CONF_DIR}/config.yam /home/ubuntu/.config/code-server/config.yaml
  sudo systemctl enable code-server@$USER
  sudo systemctl restart code-server@$USER
  exit 0
fi

echo "please specify action ./codeserver.sh install"
exit 1
