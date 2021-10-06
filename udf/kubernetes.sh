#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)
KUBESPRAY_VERSION=v2.17.0
K8S_VERSION=v1.21.5
K9S_VERSION=v0.24.15

INVENTORY_DIR_1=${ROOT_DIR}/udf/kubespray/inventory/cluster1
INVENTORY_DIR_2=${ROOT_DIR}/udf/kubespray/inventory/cluster2

ALL_NODES=( jumphost master1 node11 node12 master2 node21 node22 )
ALL_K8S_NODES=( master1 node11 node12 master2 node21 node22 )

HOME_DIR=/home/ubuntu
REPO_DIR=${HOME_DIR}/udf-aspenmesh-k8s
KUBECONF=${REPO_DIR}/udf/kubespray/kubeconfig.yaml

function do_all_nodes {
  for node in "${ALL_NODES[@]}"
  do
    echo ${node} "${1} > /dev/null"
    ssh ${node} "${1} > /dev/null"
  done
}

function do_all_k8s_nodes {
  for node in "${ALL_K8S_NODES[@]}"
  do
    echo ${node} "${1} > /dev/null"
    ssh ${node} "${1} > /dev/null"
  done
}

if [[ $1 = "install_cluster1" ]]; then
  docker pull quay.io/kubespray/kubespray:${KUBESPRAY_VERSION}
  docker run --rm -it --mount type=bind,source=${INVENTORY_DIR_1},dst=/inventory \
    --mount type=bind,source="${HOME}"/.ssh/id_rsa,dst=/root/.ssh/id_rsa \
    quay.io/kubespray/kubespray:${KUBESPRAY_VERSION} bash -c  \
    "ansible-playbook -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa --become --become-user=root cluster.yml"
  exit 0
fi

if [[ $1 = "install_cluster2" ]]; then
  docker pull quay.io/kubespray/kubespray:${KUBESPRAY_VERSION}
  docker run --rm -it --mount type=bind,source=${INVENTORY_DIR_2},dst=/inventory \
    --mount type=bind,source="${HOME}"/.ssh/id_rsa,dst=/root/.ssh/id_rsa \
    quay.io/kubespray/kubespray:${KUBESPRAY_VERSION} bash -c \
    "ansible-playbook -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa cluster.yml"
  exit 0
fi

if [[ $1 = "k9s" ]]; then
  do_all_nodes "cd /tmp ; \
  curl -LO https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz ; \
  tar xvfz k9s_Linux_x86_64.tar.gz ; \
  sudo mv k9s /usr/local/bin ; \
  rm k9s_Linux_x86_64.tar.gz"
  exit 0
fi

if [[ $1 = "kubeconfig" ]]; then
  ssh master1 "mkdir -p ${HOME_DIR}/.kube ; sudo cp /etc/kubernetes/admin.conf ${HOME_DIR}/.kube/config ; sudo chown -R ubuntu:ubuntu ${HOME_DIR}/.kube"
  scp master1:${HOME_DIR}/.kube/config /tmp/config1
  ssh node11 "mkdir -p ${HOME_DIR}/.kube"
  scp /tmp/config1 node11:${HOME_DIR}/.kube/config
  ssh node11 "chmod 600 ${HOME_DIR}/.kube/config"
  ssh node12 "mkdir -p ${HOME_DIR}/.kube"
  scp /tmp/config1 node12:${HOME_DIR}/.kube/config
  ssh node12 "chmod 600 ${HOME_DIR}/.kube/config"

  ssh master2 "mkdir -p ${HOME_DIR}/.kube ; sudo cp /etc/kubernetes/admin.conf ${HOME_DIR}/.kube/config ; sudo chown -R ubuntu:ubuntu ${HOME_DIR}/.kube"
  scp master2:${HOME_DIR}/.kube/config /tmp/config2
  ssh node21 "mkdir -p ${HOME_DIR}/.kube"
  scp /tmp/config2 node21:${HOME_DIR}/.kube/config
  ssh node21 "chmod 600 ${HOME_DIR}/.kube/config"
  ssh node22 "mkdir -p ${HOME_DIR}/.kube"
  scp /tmp/config2 node22:${HOME_DIR}/.kube/config
  ssh node22 "chmod 600 ${HOME_DIR}/.kube/config"

  exit 0
fi

if [[ $1 = "kubectl" ]]; then
  cd /tmp
  curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl"
  sudo mv kubectl /usr/local/bin
  sudo chmod +x /usr/local/bin/kubectl
  exit 0
fi

if [[ $1 = "remove_cluster1" ]]; then
  docker pull quay.io/kubespray/kubespray:${KUBESPRAY_VERSION}
  docker run --rm -it --mount type=bind,source=${INVENTORY_DIR_1},dst=/inventory \
    --mount type=bind,source="${HOME}"/.ssh/id_rsa,dst=/root/.ssh/id_rsa \
    quay.io/kubespray/kubespray:${KUBESPRAY_VERSION} bash -c  \
    "ansible-playbook -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa --become --become-user=root reset.yml"
  exit 0
fi

if [[ $1 = "remove_cluster2" ]]; then
  docker pull quay.io/kubespray/kubespray:${KUBESPRAY_VERSION}
  docker run --rm -it --mount type=bind,source=${INVENTORY_DIR_2},dst=/inventory \
    --mount type=bind,source="${HOME}"/.ssh/id_rsa,dst=/root/.ssh/id_rsa \
    quay.io/kubespray/kubespray:${KUBESPRAY_VERSION} bash -c  \
    "ansible-playbook -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa --become --become-user=root reset.yml"
  exit 0
fi

echo "please specify action ./kubernetes.sh install_cluster1/install_cluster2/k9s/kubeconfig/kubectl/remove_cluster1/remove_cluster2"
exit 1
