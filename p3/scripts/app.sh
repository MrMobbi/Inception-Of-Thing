#!/bin/bash

# Colord
RED='\e[31m'
GREEN='\e[32m' 
BLUE='\e[34m'
RESET='\e[0m'

#set -e
echo -e "${GREEN}#############"
echo -e "Building APP"
echo -e "${GREEN}#############${RESET}"

echo -e "${BLUE}=== Building Deployment ===${RESET}"
kubectl apply -f app/deployment.yaml
echo -e "${GREEN}Done.${RESET}"

echo -e "${BLUE}=== Building Deployment ===${RESET}"
kubectl apply -f app/service.yaml
echo -e "${GREEN}Done.${RESET}"

echo -e "${BLUE}=== Building Ingress ===${RESET}"
kubectl apply -f app/ingress.yaml
echo -e "${GREEN}Done.${RESET}"
