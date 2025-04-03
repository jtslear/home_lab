# Home Lab Automation

This repository contains Ansible playbooks and configurations for managing a home lab environment. It automates the deployment and maintenance of various services including Home Assistant, PiHole, Docker, Satisfactory game server, Tailscale VPN, and ESPHome.

## Overview

The automation is built using Ansible playbooks with a Makefile interface for easy execution.

## Repository Structure

The repository follows Ansible best practices with a role-based structure:

```
home_lab/
├── inventories/           # Inventory files
│   └── home/              # Home lab environment
│       ├── group_vars/    # Group variables
│       └── hosts.yml      # Inventory hosts
├── roles/                 # Ansible roles
│   ├── common/            # Common configuration for all hosts
│   ├── docker/            # Docker installation and configuration
│   ├── homeassistant/     # Home Assistant configuration
│   ├── pihole/            # PiHole configuration
│   ├── satisfactory/      # Satisfactory game server
│   ├── tailscale/         # Tailscale VPN configuration
│   ├── esphome/           # ESPHome configuration
│   ├── gitlab-runner/     # GitLab Runner configuration (disabled)
│   └── wire-pod/          # Wire-Pod configuration (disabled)
├── playbooks/             # Ansible playbooks
│   ├── site.yml           # Main playbook
│   ├── utility.yml        # Utility server playbook
│   ├── game_server.yml    # Game server playbook
│   ├── dns.yml            # DNS servers playbook
│   ├── backup_ha.yml      # Home Assistant backup playbook
│   ├── update_system.yml  # System update playbook
│   └── init_network.yml   # Network initialization playbook
└── Makefile               # Makefile interface
```

## Requirements

- Python 3
- Ansible
- [mise](https://mise.jdx.dev/) (for dependency management)

The repository uses mise for managing Python versions. The required version is specified in `.mise.toml`.

## Usage

All operations are performed through the Makefile interface. Use `make help` to see all available commands.

```
make <command>
```

## Infrastructure Details

### Home Assistant

Runs in a Docker container on the utility server with:
- Zigbee USB dongle integration
- PostgreSQL database
- NFS mount for configuration storage
- Automated backups

### PiHole

Installed on both servers for DNS and ad-blocking with:
- Automated updates
- Regular adlist updates

### Satisfactory Game Server

Runs on the dedicated game server with:
- SteamCMD for installation and updates
- Systemd service for automatic startup
- Blueprint management via Google Drive and rclone
- Daily restart for stability

> **Note**: The Google Drive service account credentials file (`*.json`) has been replaced with a placeholder in the repository. You'll need to provide your own Google Drive service account credentials to use the blueprint management feature.

### Tailscale VPN

Provides secure remote access to the home lab environment.

## Backup Strategy

Home Assistant configurations are backed up to an NFS mount, with automatic purging of backups older than 15 days.
