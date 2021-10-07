#!/usr/bin/env bash
set -o xtrace

kubectl config use-context kubernetes-admin1@cluster1.local
helm upgrade argo-cd charts/argo-cd/ --namespace argocd
