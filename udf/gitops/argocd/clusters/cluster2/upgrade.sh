#!/usr/bin/env bash
set -o xtrace

kubectl config use-context kubernetes-admin2@cluster2.local
helm upgrade argo-cd charts/argo-cd/ --namespace argocd
