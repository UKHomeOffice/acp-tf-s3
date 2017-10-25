#!/bin/bash

cd terraform
terraform get &
terraform apply &

wait
echo "Terraform apply was successful"
terraform destroy --force


