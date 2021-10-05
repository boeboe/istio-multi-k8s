#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)

DOMAIN=aspendemo.org

HOME_DIR=/home/ubuntu
REPO_DIR=${HOME_DIR}/udf-aspenmesh-k8s
CERT_DIR=${REPO_DIR}/udf/certs
GOGS_DIR=${REPO_DIR}/udf/gogs

GOGS_VERSION=0.12.3
GOGS_CONF_DIR=/home/git/gogs
GOGS_USER=aspenmesh
GOGS_PASS=aspenmesh

if [[ $1 = "install_gogs" ]]; then
  sudo apt-get -y install sqlite3
  sudo adduser --system --group --disabled-password --shell /bin/bash --home /home/git --gecos 'Git Version Control' git
  wget https://dl.gogs.io/${GOGS_VERSION}/gogs_${GOGS_VERSION}_linux_amd64.tar.gz -P /tmp
  sudo tar xf /tmp/gogs_*_linux_amd64.tar.gz -C /home/git
  sudo mkdir -p ${GOGS_CONF_DIR}/custom/https
  sudo cp ${CERT_DIR}/wildcard/${DOMAIN}.key ${GOGS_CONF_DIR}/custom/https/key.pem
  sudo cp ${CERT_DIR}/wildcard/${DOMAIN}.pem ${GOGS_CONF_DIR}/custom/https/cert.pem
  sudo cp ${GOGS_DIR}/app.ini ${GOGS_CONF_DIR}/custom/conf/app.ini
  sudo chown -R git: ${GOGS_CONF_DIR}
  sudo cp ${GOGS_CONF_DIR}/scripts/systemd/gogs.service /etc/systemd/system/
  sudo systemctl daemon-reload
  sudo systemctl start gogs
  sudo systemctl enable gogs
  sudo runuser -u git -- ${GOGS_CONF_DIR}/gogs admin create-user --name ${GOGS_USER} --password ${GOGS_PASS} --admin --email ${GOGS_USER}@${DOMAIN}
  exit 0
fi

if [[ $1 = "install_flux" ]]; then
  curl -s https://fluxcd.io/install.sh | sudo bash
  flux bootstrap git --url=ssh://git@gogs.aspendemo.org:aspenmesh/flux-system.git --branch=master --private-key-file=/home/ubuntu/.ssh/id_rsa
  curl https://github.com/fluxcd/webui/releases/download/v0.1.1/flux-webui_0.1.1_linux_amd64.tar.gz -o /tmp/flux-webui.tar.gz
  exit 0
fi

echo "please specify action ./gitops.sh install_gogs/install_flux"
exit 1