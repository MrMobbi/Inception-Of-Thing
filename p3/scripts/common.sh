#!/bin/bash

# Colord
RED='\e[31m'
GREEN='\e[32m' 
BLUE='\e[34m'
RESET='\e[0m'


#set -e
set -o pipe

echo -e "${BLUE}=== Creation of the namespace ===${RESET}"
kubectl create namespace argocd
kubectl create namespace dev
echo -e "${GREEN}Done.${RESET}"

echo -e "${BLUE}=== Adding local domain to hosts ===${RESET}"
if ! grep -q argocd.local /etc/hosts;then
  echo "127.0.0.1 argocd.local" | sudo tee -a /etc/hosts
fi

if ! grep -q app.local /etc/hosts;then
  echo "127.0.0.1 app.local" | sudo tee -a /etc/hosts
fi
echo -e "${GREEN}Done.${RESET}"
