#!/bin/bash

#stops immediately on error
set -e

echo "Provisioning with terraform..."

cd ..
cd terraform
terraform init
#Skips the yes prompt
terraform apply -auto-approve

echo "Extracting outputs"
CONTAINER_NAME=$(terraform output -raw container_name)
cd ..
cd ansible

echo "Generating inventory"

cat <<EOF > inventory.ini
[containers]
$CONTAINER_NAME ansible_connection=docker
EOF

echo "installing python"
ansible containers -i inventory.ini -m raw -a "apt-get update && apt-get install -y python3"

echo "Applying Ansible playbook"
ansible-playbook -i inventory.ini playbook.yml

echo "Deployment complete. Webpage at http://localhost:8080"