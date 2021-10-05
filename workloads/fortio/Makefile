# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


install: ## Install fortio client and server 
	./fortio.sh install

uninstall: ## Uninstall fortio client and server
	./fortio.sh uninstall

info: ## Get deployment info of this workload
	./fortio.sh info

restart: ## Restart all pods in this fortio namespace
	./fortio.sh restart

check-endpoints: ## Check envoy sidecar endpoints
	./fortio.sh check_endpoints

check-priorities: ## Check envoy sidecar priorities
	./fortio.sh check_priorities

test-traffic: ## Run fortio client traffic generator to fortio server
	./fortio.sh test_traffic

test-traffic-infinite: ## Run fortio client traffic generator to fortio server until ^C
	./fortio.sh test_traffic_infinite

delete-server: ## Delete fortio-server
	./fortio.sh delete_server

scale-up-server: ## Scale up fortio-server
	./fortio.sh scale_up_server:

scale-down-server: ## Scale down fortio-server
	./fortio.sh scale_down_server
