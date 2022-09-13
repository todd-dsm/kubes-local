#!/usr/bin/env make
# vim: tabstop=8 noexpandtab

# Grab some ENV stuff
TF_VAR_myProject	?= $(shell $(TF_VAR_myProject))
TF_VAR_envBuild 	?= $(shell $(TF_VAR_envBuild))

# Start Terraforming
all:	tf-init plan apply

init:	## Initialze the build
	minikube start
	minikube status

addr:	## Retrieve the public_ip address from the Instance
	terraform state show module.compute.aws_instance.test_instance | grep 'public_ip' | grep -v associate_public_ip_address

state:	## View the Terraform State File in VS-Code
	@scripts/view-tf-state.sh

clean:	## Clean WARNING Message
	@echo ""
	@echo "    ***** STOP, THINK ABOUT THIS *****"
	@echo "You're about to DESTROY ALL that we have built"
	@echo ""
	@echo "IF YOU'RE CERTAIN, THEN 'make clean-all'"
	@echo ""
	@exit

clean-all:	## Destroy Terraformed resources and all generated files with output log
	minikube stop
	minikube delete
	@echo "Done!"

#-----------------------------------------------------------------------------#
#------------------------   MANAGERIAL OVERHEAD   ----------------------------#
#-----------------------------------------------------------------------------#
print-%  : ## Print any variable from the Makefile (e.g. make print-VARIABLE);
	@echo $* = $($*)

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

