#!/bin/bash

#set -e

echo -e "${BLUE}=== Creation of the namespace ===${RESET}"

kubectl create namespace argocd
kubectl create namespace dev
echo -e "${GREEN}Done.${RESET}"
