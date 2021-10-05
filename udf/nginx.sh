#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)

NGINX_CONF_DIR=${ROOT_DIR}/udf/nginx


if [[ $1 = "jumphost" ]]; then
  sudo rm -rf /etc/nginx/conf.d/*.conf
  sudo cp ${NGINX_CONF_DIR}/jumphost/3*.conf /etc/nginx/conf.d/
  sudo cp ${NGINX_CONF_DIR}/jumphost/nginx.conf /etc/nginx/nginx.conf
  sudo systemctl enable nginx.service
  sudo systemctl restart nginx.service
  exit 0
fi

if [[ $1 = "status" ]]; then
  sudo systemctl status nginx.service
  exit 0
fi

echo "please specify action ./nginx.sh jumphost/status"
exit 1