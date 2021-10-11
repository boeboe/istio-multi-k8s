#!/usr/bin/env bash
set -o xtrace

kubectl config use-context kubernetes-admin1@cluster1.local
kubectl create namespace argocd
helm install argo-cd charts/argo-cd/ --namespace argocd

kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$we6qNnR7Aojjzt/WX4ZZ5.TEEL5R9Frhb2B0fVg4dNG1y4whOa8vS",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

helm template apps/ | kubectl apply -n argocd -f -

argocd login 10.1.1.50:443 --username admin --password admin
argocd repo add git@gogs.aspendemo.org:aspenmesh/istio.git --ssh-private-key-path ~/.ssh/id_rsa --insecure-ignore-host-key
argocd repo add git@gogs.aspendemo.org:aspenmesh/helloworld.git --ssh-private-key-path ~/.ssh/id_rsa --insecure-ignore-host-key
