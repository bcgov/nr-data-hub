#!/bin/bash

command || true

case "$1" in
  init)
    terraform init -backend-config="./config/$2.tfbackend" -upgrade
    ;;
  plan)
    terraform plan -out=plan -refresh=false -var-file="./config/$2.tfvars"
    ;;
  apply)
    terraform apply plan
    ;;
  destroy)
    terraform plan -out=plan -destroy -refresh=false
    terraform apply plan
  *
    echo "Invalid argument. Use one of: init, plan, apply, destroy."
    exit 1
    ;;
esac