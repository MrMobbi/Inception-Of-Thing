#!/usr/bin/env bash

set -Eeuo pipefail

readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly RESET='\033[0m'

info() {
    printf '%b==> %s%b\n' "$BLUE" "$1" "$RESET"
}

success() {
    printf '%b==> %s%b\n' "$GREEN" "$1" "$RESET"
}

if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script with sudo." >&2
    echo "Run: make build" >&2
    exit 1
fi

info "Checking Kubernetes connectivity"

kubectl cluster-info >/dev/null
kubectl get nodes

info "Creating namespaces"

kubectl create namespace argocd \
    --dry-run=client \
    -o yaml |
    kubectl apply -f -

kubectl create namespace dev \
    --dry-run=client \
    -o yaml |
    kubectl apply -f -

success "Namespaces are ready"

info "Adding local domains to /etc/hosts"

if ! grep -Eq '^[[:space:]]*127\.0\.0\.1[[:space:]]+.*\bargocd\.local\b' /etc/hosts; then
    echo '127.0.0.1 argocd.local' | sudo tee -a /etc/hosts >/dev/null
fi

if ! grep -Eq '^[[:space:]]*127\.0\.0\.1[[:space:]]+.*\bapp\.local\b' /etc/hosts; then
    echo '127.0.0.1 app.local' | sudo tee -a /etc/hosts >/dev/null
fi
