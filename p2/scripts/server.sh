#!/bin/bash
set -e

SERVER_IP=$1

echo " === Starting k3s server installation ==="
echo "Server IP: ${SERVER_IP}"

if systemctl is-active --quiet k3s; then
	echo "k3s is already installed. Skipping."
else
	echo "=== Installing k3s server ==="
	curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
	  --node-ip=${SERVER_IP} \
	  --bind-address=${SERVER_IP} \
	  --advertise-address=${SERVER_IP} \
	  --write-kubeconfig-mode=644 \
	  --tls-san=${SERVER_IP}" sh - 1>/dev/null
fi

echo " === Checking for k3s Api ==="

K3S_BIN=/usr/local/bin/k3s
MAX_RETRIES=5
COUNT=0

until [ "$($K3S_BIN kubectl get nodes -o jsonpath='{.items[0].status.conditions[?(@.type=="Ready")].status}')" == "True" ]; do
    COUNT=$((COUNT+1))
    if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
        echo "Kubernetes API did not become ready after $MAX_RETRIES attempts. Exiting."
        exit 1
    fi
    echo "Waiting for Kubernetes API to be ready... attempt $COUNT/$MAX_RETRIES"
    sleep 5
done

echo "Kubernetes API is ready!"

echo "=== k3s server installation complete ==="
$K3S_BIN kubectl get nodes
echo "Done."
