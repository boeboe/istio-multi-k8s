#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)

GIT_REPO=https://github.com/CloudDevOpsEMEA/udf-istio-multi-k8s

HOME_DIR=/home/ubuntu
REPO_DIR=${HOME_DIR}/udf-istio-multi-k8s
CERT_DIR=${REPO_DIR}/udf/certs

NODES=( jumphost master1 node1 master2 node2 master3 node3 )
K8S_NODES=( master1 node1 master2 node2 master3 node3 )


function do_nodes {
  for node in "${NODES[@]}"
  do
    echo ${node} "${1} > /dev/null"
    ssh ${node} "${1} > /dev/null"
  done
}

function do_k8s_nodes {
  for k8s_node in "${K8S_NODES[@]}"
  do
    echo ssh ${k8s_node} "${1}"
    ssh ${k8s_node} "${1}"
  done
}


if [[ $1 = "apt_install" ]]; then
  do_nodes "sudo apt-get -y install make ansible python-jinja2 python-netaddr python3-pip systemd grc nmap tree siege"
  exit 0
fi

if [[ $1 = "apt_fix" ]]; then
  do_k8s_nodes "sudo apt-get -y -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' install containerd.io=1.3.9-1 docker-ce-cli=5:19.03.14~3-0~ubuntu-bionic docker-ce=5:19.03.14~3-0~ubuntu-bionic --allow-downgrades --allow-change-held-packages"
  exit 0
fi

if [[ $1 = "apt_update" ]]; then
  do_nodes "sudo apt-get -y update ; sudo apt-get -y upgrade ; sudo apt-get -y dist-upgrade ; sudo apt-get -y autoremove"
  exit 0
fi

if [[ $1 = "git_clone" ]]; then
  do_k8s_nodes "cd ${HOME_DIR} ; git clone ${GIT_REPO} > /dev/null"
  exit 0
fi

if [[ $1 = "git_pull" ]]; then
  do_nodes "cd ${REPO_DIR}; git pull > /dev/null ; sudo updatedb"
  exit 0
fi

if [[ $1 = "reboot_k8s" ]]; then
  do_k8s_nodes "sudo reboot"
  exit 0
fi

if [[ $1 = "install_root_ca" ]]; then
  do_nodes "sudo cp ${CERT_DIR}/root-cert.pem /usr/local/share/ca-certificates/Aspendemo_Root_CA.crt ; sudo update-ca-certificates"
  exit 0
fi

echo "please specify action ./nodes.sh apt_install/apt_fix/apt_update/git_clone/git_pull/reboot_k8s/install_root_ca"
exit 1
