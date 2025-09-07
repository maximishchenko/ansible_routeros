INVENTORY ?= inventory/inventory.yml
VAULT_PASSWORD_FILE ?= .vaultpass
SHELL:=/bin/bash

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
		ansible-playbook -i $(INVENTORY) get_backup.yml -e type=$(TYPE) --vault-password-file=$(VAULT_PASSWORD_FILE)
	fi

.SILENT:
.PHONY: setup-control-host
setup-control-host: # Prepare control host for environment. Ask sudo password
	ansible-playbook setup_control_host.yml --ask-become-pass

.SILENT:
.PHONY: create-inventory-file
create-inventory-file: # Create inventory.yml file inside inventory directory from inventory.sample.yml template file
	if [ ! -f inventory/inventory.sample.yml ]; 
		then
		echo "Error: inventory template file not found"
		exit 1
	fi;
	cp inventory/inventory.sample.yml inventory/inventory.yml


.SILENT:
.ONESHELL:
.PHONY: create-group-template
create-group-template: # Prepare group_vars from template file (group_vars/sample.yml) without comments
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

.SILENT:
.ONESHELL:
.PHONY: encrypt-group-vars
encrypt-group-vars: # Encrypt all files inside group_vars directory except sample.yml if not encrypted earlier
	if [ ! -f $(VAULT_PASSWORD_FILE) ]; 
	then
		read -sp "Warning. File $$VAULT_PASSWORD_FILE does not exists. Please input password for ansible-vault: " vault_pass
		if [ -z "$$vault_pass" ]; 
		then
			echo "Error: vaultpass value is missing."
			exit 1
		fi;
		echo "$$vault_pass" > .vaultpass
		chmod 0600 $(VAULT_PASSWORD_FILE)
		echo ""
		echo "Vault password are stored at $$VAULT_PASSWORD_FILE with 0600 permissions."
	fi;
	for file in group_vars/*; do 
		if [ "$$file" != "group_vars/sample.yml" ] && [ -f "$$file" ] && ! grep -q 'ANSIBLE_VAULT' "$$file"
		then
			echo "Warning. File $$file will be encrypted."
			ansible-vault encrypt "$$file" --vault-password-file=$(VAULT_PASSWORD_FILE)
		else
			echo "Info. File $$file will be skipped. Always encrypted or template."
		fi
	done

