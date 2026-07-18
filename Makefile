.PHONY: help topo-reload exp-reload full-reload exp-stop

.ONESHELL:

SHELL=/bin/bash
PHENIX=docker exec -it phenix phenix
BRANCH_NAME?=test
export BRANCH_NAME


PHENIX_HOST="http://localhost:3000"
WORKFLOW_API=$(PHENIX_HOST)/api/v1/workflow


# Show this help
help:
	@cat $(MAKEFILE_LIST) | docker run --rm -i xanders/make-help

# Reload topology and scenario
topo-reload:
	envsubst < topology.yml | curl -X POST -H "Content-Type: application/x-yaml" --data-binary @- $(WORKFLOW_API)/configs/$(BRANCH_NAME)
	envsubst < scenario.yml | curl -X POST -H "Content-Type: application/x-yaml" --data-binary @- $(WORKFLOW_API)/configs/$(BRANCH_NAME)

# Reload and start the experiment
exp-reload: 
	curl -X POST -H "Content-Type: application/x-yaml" --data-binary "@.phenix.yml" $(WORKFLOW_API)/apply/$(BRANCH_NAME)

# Reload topology and scenario and restart experiment
full-reload: topo-reload exp-reload

# Stop the experiment
exp-stop:
	$(PHENIX) exp stop $(BRANCH_NAME) || true

