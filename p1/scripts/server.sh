#!/bin/bash
set -e

SERVER_IP=$1
TOKEN=$2

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
	  --token=${TOKEN} \
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

echo "=== Waiting for worker node to join ==="
MAX_RETRIES=10
COUNT=0

until [ "$($K3S_BIN kubectl get nodes --no-headers | wc -l)" -eq 2 ]; do
    COUNT=$((COUNT+1))
    if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
        echo "Worker node not ready after $MAX_RETRIES attempts. Exiting."
        exit 1
    fi
    echo "Waiting for worker node to joins... attempt $COUNT/$MAX_RETRIES"
    sleep 5
done

$K3S_BIN kubectl label node mjulliatsw node-role.kubernetes.io/worker=worker

echo "=== k3s server installation complete ==="
$K3S_BIN kubectl get nodes
echo "Done."
