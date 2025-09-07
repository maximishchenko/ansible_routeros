INVENTORY ?= inventory/inventory.yml

default: help

.SILENT:
.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.SILENT:
.ONESHELL:
.PHONY: backup
backup: # Create backup of RouterOS device. You must pass TYPE parameter value. TYPE must be one of 'backup', 'export'
	if [ -z "$(TYPE)" ];
	then
		echo "Error: Missing TYPE argument."
		exit 1
	else
		ansible-playbook -i $(INVENTORY) get_backup.yml -e type=$(TYPE)
	fi

.SILENT:
.PHONY: setup-control-host
setup-control-host: # Prepare control host for environment. Ask sudo password
	ansible-playbook setup_control_host.yml --ask-become-pass

.SILENT:
.ONESHELL:
.PHONY: create-group-template
create-group-template: # Prepare group_vars from template file (group_vars/sample.yml) without comments
	$(eval SHELL:=/bin/bash)
	if [ ! -f group_vars/sample.yml ]; 
		then
		echo "Error: template file not found"
		exit 1
	fi;

	read -p "Please input group name (without .yml extension): " filename
	if [ -z "$$filename" ]; 
		then
		echo "Error: group name is missing"
		exit 1
	fi;

	sed 's/#.*$$//' group_vars/sample.yml > "group_vars/$$filename.yml" && cat "group_vars/$$filename.yml"
