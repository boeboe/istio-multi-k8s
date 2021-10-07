#!/usr/bin/env bash
set -o xtrace

kubectl config use-context kubernetes-admin1@cluster1.local
helm uninstall argo-cd --namespace argocd
