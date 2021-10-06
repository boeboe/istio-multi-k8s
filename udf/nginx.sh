#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)

NGINX_CONF_DIR=${ROOT_DIR}/udf/nginx


if [[ $1 = "install" ]]; then
  sudo cp ${NGINX_CONF_DIR}/nginx.list /etc/apt/sources.list.d/nginx.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62
  sudo apt-get update
  sudo apt-get -y install nginx
  sudo systemctl enable nginx.service
  sudo systemctl start nginx.service
  exit 0
fi

if [[ $1 = "config" ]]; then
  sudo rm -rf /etc/nginx/conf.d/*.conf
  sudo cp ${NGINX_CONF_DIR}/jumphost/*-*.conf /etc/nginx/conf.d/
  sudo cp ${NGINX_CONF_DIR}/jumphost/nginx.conf /etc/nginx/nginx.conf
  sudo systemctl enable nginx.service
  sudo systemctl restart nginx.service
  exit 0
fi

if [[ $1 = "status" ]]; then
  sudo systemctl status nginx.service
  exit 0
fi

echo "please specify action ./nginx.sh install/config/status"
exit 1
