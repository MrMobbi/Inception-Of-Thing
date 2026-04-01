#!/bin/bash

# Colord
RED='\e[31m'
GREEN='\e[32m' 
BLUE='\e[34m'
RESET='\e[0m'

#set -e

echo -e "${BLUE}=== Creation of the namespace ===${RESET}"
kubectl create namespace argocd
kubectl create namespace dev
echo -e "${GREEN}Done.${RESET}"

echo -e "${BLUE}=== Generating secret and ssl ===${RESET}"
# creating tls to access argocs with https
if [ ! -d secret ];then
  mkdir secret
else
  echo "### Folder secret exist ###"
fi

if [ ! -f secret/certificate.pem ] || [ ! -f secret/privatekey.pem ];then
  openssl req -newkey rsa:4096 \
    -x509 -sha512 -days 365 -nodes \
    -out secret/certificate.pem \
    -keyout secret/privatekey.pem \
    -subj "/CN=argocd.local" \
    -addext "subjectAltName=DNS:argocd.local"
else
  echo "### ssl exist ###"
fi

kubectl create secret tls argocd-tls \
--cert=secret/certificate.pem \
--key=secret/privatekey.pem \
-n argocd || true
echo -e "${GREEN}Done.${RESET}"

echo -e "${BLUE}=== Installing argoCD and configure argo resources ===${RESET}"
# install and configure argoCD
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch configmap argocd-cmd-params-cm -n argocd \
  --type merge \
  -p '{"data":{"server.insecure":"true"}}'

kubectl apply -f config/argocd_ingress.yaml
echo -e "${GREEN}Done.${RESET}"
