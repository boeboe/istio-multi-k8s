# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


kubernetes_install_cluster1: ## Install clean Kubernetes Cluster 1
	./udf/kubernetes.sh install_cluster1
kubernetes_install_cluster2: ## Install clean Kubernetes Cluster 2
	./udf/kubernetes.sh install_cluster2

kubernetes_k9s: ## Install k9s
	./udf/kubernetes.sh k9s

kubernetes_kubeconfig: ## Fetch correct kubeconfig
	./udf/kubernetes.sh kubeconfig

kubernetes_kubectl: ## Install kubectl
	./udf/kubernetes.sh kubectl

kubernetes_remove_cluster1: ## Remove existing Kubernetes Cluster 1
	./udf/kubernetes.sh remove_cluster1
kubernetes_remove_cluster2: ## Remove existing Kubernetes Cluster 2
	./udf/kubernetes.sh remove_cluster2

aspenmesh_install: ## Install clean Aspen Mesh
	./udf/aspenmesh.sh install

aspenmesh_update: ## Update existng Aspen Mesh
	./udf/aspenmesh.sh update

aspenmesh_remove: ## Remove existing Aspen Mesh
	./udf/aspenmesh.sh remove

aspenmesh_istioctl: ## Install Aspen Mesh matching istioctl
	./udf/aspenmesh.sh istioctl

aspenmesh_services: ## Expose Aspen Mesh services
	./udf/aspenmesh.sh services

hosts_apt_install: ## Install packages on all nodes
	./udf/nodes.sh apt_install

hosts_apt_fix: ## Fix locked packages on all nodes
	./udf/nodes.sh apt_fix

hosts_apt_update: ## Upgrade packages on all nodes
	./udf/nodes.sh apt_update

hosts_git_clone: ## Clone repo on all nodes
	./udf/nodes.sh git_clone

hosts_git_pull: ## Pull repo on all nodes
	./udf/nodes.sh git_pull

hosts_reboot_k8s: ## Reboot all k8s nodes
	./udf/nodes.sh reboot_k8s

hosts_install_root_ca: ## Install Aspendemo Root CA on all nodes
	./udf/nodes.sh install_root_ca

nginx_install: ## Install nginx 
	./udf/nginx.sh install

nginx_config: ## Refresh nginx configuration
	./udf/nginx.sh config

nginx_status: ## Get nginx daemon status
	./udf/nginx.sh status

dns_dnsmasq: ## Install and setup dnsmasq
	./udf/dns.sh dnsmasq

dns_dnsclient: ## Set DNS client configuration
	./udf/dns.sh dnsclient

dns_hosts: ## Update /etc/hosts file for dnsmasq server
	./udf/dns.sh hosts

gogs_install: ## Install Gogs as Git Server
	./udf/gitops.sh install_gogs

codeserver_install: ## Install Code Server as HTTP based Editor
	./udf/codeserver.sh install

flux_install: ## Install Flux as Gitops integration
	./udf/gitops.sh install_flux

integration_datadog_install: ## Install Datadog agent
	./integrations/datadog.sh install

integration_datadog_update: ## Update Datadog agent
	./integrations/datadog.sh update

integration_datadog_remove: ## Remove Datadog agent
	./integrations/datadog.sh remove
