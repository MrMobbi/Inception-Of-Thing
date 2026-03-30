#!/bin/bash
set -e

SERVER_IP=$1
TOKEN=$2

echo "=== Starting k3s worker installation ==="
echo "Server IP: ${SERVER_IP}"

# Install k3s agent if not already installed
if systemctl is-active --quiet k3s-agent; then
    echo "k3s agent is already installed. Skipping."
else
    echo "=== Installing k3s worker ==="
    curl -sfL https://get.k3s.io | K3S_URL="https://${SERVER_IP}:6443" \
        K3S_TOKEN="${TOKEN}" sh -s - agent 1>/dev/null
fi

echo "=== k3s worker installation complete ==="
