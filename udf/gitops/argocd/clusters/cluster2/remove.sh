#!/usr/bin/env bash
set -o xtrace

kubectl config use-context kubernetes-admin2@cluster2.local
helm uninstall argo-cd --namespace argocd
