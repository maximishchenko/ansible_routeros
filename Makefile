INVENTORY ?= inventory/inventory.yml

default: help

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: binary-dump
binary-dump: # Create binary dump of RouterOS device
	ansible-playbook -i $(INVENTORY) get_binary_dump.yml

.PHONY: export-config
export-config: # Create export configuration of RouterOS device
	ansible-playbook -i $(INVENTORY) get_export_config.yml

.PHONY: prepare
prepare: # Prepare management host for environment
	ansible-playbook install_requirements.yml --ask-become-pass
