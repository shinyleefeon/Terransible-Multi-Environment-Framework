# Terransible-Multi-Environment-Framework
# Zero-Cost Containerized IaC Pipeline

## Overview
An automated, local-first Infrastructure as Code (IaC) pipeline that provisions containerized infrastructure and orchestrates configuration management without relying on cloud provider credits. This project demonstrates the transition from manual systems administration to declarative infrastructure deployment and automated server configuration.

## Architecture & Tech Stack
* **Infrastructure Provisioning:** Terraform (Docker Provider)
* **Configuration Management:** Ansible (Docker Connection Plugin)
* **Target Environment:** Local Ubuntu 22.04 containers via WSL
* **Deployment Automation:** Bash shell scripting

## Pipeline Workflow
The deployment lifecycle is handled entirely by a wrapper script (`deploy.sh`) that executes the following sequence:
1. **Provisioning:** Terraform establishes an isolated virtual Docker network and boots an Ubuntu 22.04 container configured for background persistence.
2. **State Extraction:** The pipeline queries the local Terraform state to dynamically extract the assigned container name and IP address.
3. **Dynamic Inventory:** An Ansible `inventory.ini` file is generated on the fly using the extracted outputs, eliminating hardcoded infrastructure references.
4. **Bootstrapping:** Ansible's `raw` module bypasses the standard SSH requirement to inject Python3 directly into the barebones container via the Docker socket.
5. **Configuration:** An idempotent Ansible playbook executes against the dynamic inventory, deploying and configuring an Nginx web server with custom web assets.

## Execution
Ensure Docker Desktop is running with WSL integration enabled.

**Deploy the environment:**
\`\`\`bash
./ansible/deploy.sh
\`\`\`
*Navigate to http://localhost:8080 to view the provisioned web server.*

**Destroy the environment:**
\`\`\`bash
./destroy.sh
\`\`\`
