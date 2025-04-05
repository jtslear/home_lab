UNAME := $(shell uname -s)
export OS := $(shell uname -s)
ARCH := $(shell uname -m)
GREEN := $(shell tput -Txterm setaf 4)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE := $(shell tput -Txterm setaf 7)
CYAN := $(shell tput -Txterm setaf 6)
RESET := $(shell tput -Txterm sgr0)

INVENTORY := inventories/home/hosts.yml
ROLES_PATH := roles

.PHONY: help
help: ## Show this help information
	@echo ''
	@echo 'Usage:'
	@echo ' ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "    ${CYAN}%s${RESET}\n", substr($$1,4)} \
	}' $(MAKEFILE_LIST)

## Workstation Commands
.PHONY: ws-setup
ws-setup: ## Set up local workstation with required dependencies
	mise trust # Trust the .mise.toml file
	mise install
	python -V
	python -m pip -V
	python -m pip install --user ansible
	ansible --version

## Infrastructure Commands
.PHONY: infra-ping
infra-ping: ## Check connectivity to all servers
	ansible all -m ping -i $(INVENTORY)

.PHONY: infra-init
infra-init: ## Initialize all servers with basic configuration
	ansible-playbook --ask-pass --ask-become-pass --inventory $(INVENTORY) playbooks/init_network.yml

.PHONY: infra-update
infra-update: ## Update OS and dependencies on all servers
	ansible-playbook --inventory $(INVENTORY) playbooks/update_system.yml

.PHONY: infra-deploy-all
infra-deploy-all: ## Deploy all services to all servers
	ansible-playbook --ask-become-pass --inventory $(INVENTORY) -b playbooks/site.yml

## Home Assistant Commands
.PHONY: ha-deploy
ha-deploy: ## Deploy/update Home Assistant
	ansible-playbook --ask-become-pass --inventory $(INVENTORY) -b playbooks/ha-deploy.yml

.PHONY: ha-backup
ha-backup: ## Backup Home Assistant configuration
	ansible-playbook -v --inventory $(INVENTORY) playbooks/backup_ha.yml

## PiHole Commands
.PHONY: pihole-deploy
pihole-deploy: ## Deploy/update PiHole
	ansible-playbook --inventory $(INVENTORY) playbooks/dns.yml

## ESPHome Commands
.PHONY: esphome-deploy
esphome-deploy: ## Deploy/update ESPHome
	ansible-playbook --ask-become-pass --inventory $(INVENTORY) -b playbooks/esphome.yml

## Satisfactory Commands
.PHONY: satisfactory-deploy
satisfactory-deploy: ## Deploy/update Satisfactory game server
	ansible-playbook --ask-become-pass --inventory $(INVENTORY) playbooks/game_server.yml

## Tailscale Commands
.PHONY: tailscale-deploy
tailscale-deploy: ## Deploy/update Tailscale VPN
	ansible-playbook --inventory $(INVENTORY) -b playbooks/tailscale.yml

## Disabled Services
.PHONY: gitlab-runner-deploy
gitlab-runner-deploy: ## Deploy/update GitLab Runner (currently disabled)
	echo "Disabled."

.PHONY: wire-pod-deploy
wire-pod-deploy: ## Deploy/update Wire-Pod (currently disabled)
	echo "Disabled."
