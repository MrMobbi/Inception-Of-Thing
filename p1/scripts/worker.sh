#!/usr/bin/env bash
set -euxo pipefail

SERVER_IP="${1}"
WORKER_IP="${2}"

# Wait for server to write token
for i in $(seq 1 30); do
  if [ -s /var/lib/rancher/k3s/server/node-token ]; then
    break
  fi
  echo "Waiting for /vagrant/k3s-node-token... ($i/30)"
  sleep 2
done

  if [ -s /var/lib/rancher/k3s/server/node-token ]; then
  echo "ERROR: token not found. Server provisioning may have failed."
  exit 1
fi

TOKEN="$(cat /vagrant/k3s-node-token)"

# Install k3s
curl -sfL https://get.k3s.io | \
  K3S_URL="https://${SERVER_IP}:6443" \
  K3S_TOKEN="${TOKEN}" \
  INSTALL_K3S_EXEC="agent --node-ip ${WORKER_IP}" sh -

