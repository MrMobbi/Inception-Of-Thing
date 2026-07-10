#!/usr/bin/env bash

set -Eeuo pipefail

readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly RESET='\033[0m'

readonly ARGOCD_NAMESPACE="argocd"
readonly CERT_DIR="secret"
readonly CERT_FILE="${CERT_DIR}/certificate.pem"
readonly KEY_FILE="${CERT_DIR}/privatekey.pem"
readonly ARGOCD_INSTALL_URL="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"

info() {
    printf '%b==> %s%b\n' "$BLUE" "$1" "$RESET"
}

success() {
    printf '%b==> %s%b\n' "$GREEN" "$1" "$RESET"
}

if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script with sudo." >&2
    exit 1
fi

kubectl get namespace "$ARGOCD_NAMESPACE" >/dev/null

info "Generating the Argo CD TLS certificate"

mkdir -p "$CERT_DIR"

if [[ ! -f "$CERT_FILE" || ! -f "$KEY_FILE" ]]; then
    openssl req \
        -newkey rsa:4096 \
        -x509 \
        -sha512 \
        -days 365 \
        -nodes \
        -out "$CERT_FILE" \
        -keyout "$KEY_FILE" \
        -subj "/CN=argocd.local" \
        -addext "subjectAltName=DNS:argocd.local"
else
    echo "Certificate already exists"
fi

kubectl create secret tls argocd-tls \
    --namespace "$ARGOCD_NAMESPACE" \
    --cert "$CERT_FILE" \
    --key "$KEY_FILE" \
    --dry-run=client \
    -o yaml |
    kubectl apply -f -

success "TLS secret is ready"

info "Installing Argo CD"

kubectl apply \
    --namespace "$ARGOCD_NAMESPACE" \
    --server-side \
    --force-conflicts \
    --filename "$ARGOCD_INSTALL_URL"

kubectl patch configmap argocd-cmd-params-cm \
    --namespace "$ARGOCD_NAMESPACE" \
    --type merge \
    --patch '{"data":{"server.insecure":"true"}}'

info "Waiting for the Argo CD server"

kubectl rollout status deployment/argocd-server \
    --namespace "$ARGOCD_NAMESPACE" \
    --timeout=300s

info "Applying ingress and application resources"

kubectl apply --filename argocd/ingress.yaml
kubectl apply --filename argocd/application.yaml
