#!/usr/bin/env bash
set -o xtrace

ROOT_DIR=$(pwd)
KUBESPRAY_VERSION=v2.17.0
K8S_VERSION=v1.21.5
K9S_VERSION=v0.24.15

INVENTORY_DIR_1=${ROOT_DIR}/udf/kubespray/inventory/cluster1
INVENTORY_DIR_2=${ROOT_DIR}/udf/kubespray/inventory/cluster2
INVENTORY_DIR_3=${ROOT_DIR}/udf/kubespray/inventory/cluster3

KUBECONF_NODES=( jumphost node1 node2 node3 node4 )

HOME_DIR=/home/ubuntu
REPO_DIR=${HOME_DIR}/udf-aspenmesh-k8s
KUBECONF=${REPO_DIR}/udf/kubespray/kubeconfig.yaml

function do_nodes {
  for node in "${KUBECONF_NODES[@]}"
  do
    echo ${node} "${1} > /dev/null"
    ssh ${node} "${1} > /dev/null"
  done
}

if [[ $1 = "install" ]]; then
  docker pull quay.io/kubespray/kubespray:${KUBESPRAY_VERSION}
  docker run --rm -it --mount type=bind,source=${INVENTORY_DIR_1},dst=/inventory \
    --mount type=bind,source="${HOME}"/.ssh/id_rsa,dst=/root/.ssh/id_rsa \
    quay.io/kubespray/kubespray:v2.16.0 bash -c \
    ansible-playbook -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa cluster.yml



  cd ${KUBESPRAY_DIR}
  sudo pip3 install -r requirements.txt
  ansible-playbook -i ${INVENTORY_DIR}/hosts.yaml  --become --become-user=root cluster.yml
  exit 0
fi

if [[ $1 = "k9s" ]]; then
  cd /tmp
  curl -LO "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz"
  tar xvfz k9s_Linux_x86_64.tar.gz
  sudo mv k9s /usr/local/bin
  rm k9s_Linux_x86_64.tar.gz
  exit 0
fi

if [[ $1 = "kubeconfig" ]]; then
  ssh master 'sudo cp /etc/kubernetes/admin.conf ~/.kube/config'
  do_nodes "cp ${KUBECONF} ${HOME_DIR}/.kube/config"
  exit 0
fi

if [[ $1 = "kubectl" ]]; then
  cd /tmp
  curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl"
  sudo mv kubectl /usr/local/bin
  sudo chmod +x /usr/local/bin/kubectl
  exit 0
fi

if [[ $1 = "update" ]]; then
  cd ${KUBESPRAY_DIR}
  sudo pip3 install -r requirements.txt
  ansible-playbook -i ${INVENTORY_DIR}/hosts.yaml  --become --become-user=root -e kube_version=${K8S_VERSION} -e upgrade_cluster_setup=true cluster.yml
  exit 0
fi

if [[ $1 = "remove" ]]; then
  cd ${KUBESPRAY_DIR}
  sudo pip3 install -r requirements.txt
  ansible-playbook -i ${INVENTORY_DIR}/hosts.yaml --become --become-user=root reset.yml 
  exit 0
fi


echo "please specify action ./kubernetes.sh install/k9s/kubeconfig/kubectl/update/remove"
exit 1
