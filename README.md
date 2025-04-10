# Home Lab Automation

This repository contains Ansible playbooks and configurations for managing a home lab environment. It automates the deployment and maintenance of various services including Home Assistant, PiHole, Docker, Satisfactory game server, Tailscale VPN, and ESPHome.

## Overview

The automation is built using Ansible playbooks with mise tasks for easy execution.

## Repository Structure

The repository follows Ansible best practices with a role-based structure:

```
home_lab/
├── inventory/             # Inventory files
│   ├── hosts.yml          # Inventory hosts
│   └── group_vars/        # Group variables
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
│   ├── game_server.yml    # Game server playbook
│   ├── dns.yml            # DNS servers playbook
│   ├── ha-deploy.yml      # Home Assistant deployment playbook
│   ├── backup_ha.yml      # Home Assistant backup playbook
│   ├── esphome.yml        # ESPHome deployment playbook
│   ├── tailscale.yml      # Tailscale deployment playbook
│   ├── update_system.yml  # System update playbook
│   └── init_network.yml   # Network initialization playbook
└── .mise.toml             # mise configuration and tasks
```

## Requirements

- Python 3
- Ansible
- [mise](https://mise.jdx.dev/) (for dependency management and task execution)

The repository uses mise for managing Python versions and task execution. The required Python version and available tasks are specified in `.mise.toml`.

## Usage

All operations are performed through mise tasks.

To see all available tasks:

```
mise task list
```

To run a specific task:

```
mise run <task>
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
