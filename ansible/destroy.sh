#!/bin/bash

echo "Tearing down infrastructure with terraform..."

cd ..
cd terraform
terraform destroy -auto-approve
cd ..
cd ansible

echo "So long eh artifacts!"
rm -f inventory.ini

echo "All done!"