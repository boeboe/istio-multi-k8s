#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)

DNS_CONF_DIR=${ROOT_DIR}/udf/dns


if [[ $1 = "dnsmasq" ]]; then
  sudo apt-get install -y dnsmasq dnsutils ldnsutils
  sudo cp ${DNS_CONF_DIR}/dnsmasq.conf /etc/dnsmasq.conf
  sudo systemctl restart dnsmasq
  exit 0
fi

if [[ $1 = "dnsclient" ]]; then
  sudo apt-get install -y dnsutils ldnsutils
  sudo systemctl disable --now systemd-resolved
  sudo rm -rf /etc/resolv.conf
  sudo cp ${DNS_CONF_DIR}/resolv.conf /etc/resolv.conf
  sudo cp ${DNS_CONF_DIR}/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
  exit 0
fi

if [[ $1 = "hosts" ]]; then
  cat ${DNS_CONF_DIR}/hosts | sudo tee /etc/hosts
  sudo systemctl restart dnsmasq
  exit 0
fi

echo "please specify action ./dns.sh dnsmasq/dnsclient/hosts"
exit 1
