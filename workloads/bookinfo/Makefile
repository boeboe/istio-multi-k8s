# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


install: ## Install bookinfo 
	./bookinfo.sh install

uninstall: ## Uninstall bookinfo
	./bookinfo.sh uninstall

info: ## Get deployment info of bookinfo
	./bookinfo.sh info

restart: ## Restart all pods in this bookinfo namespace
	./bookinfo.sh restart
