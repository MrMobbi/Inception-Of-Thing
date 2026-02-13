#!/bin/bash

set -euxo pipefail

SERVER_IP="${1}"

# install k3s
curl -sFL https://get.k3s.io | INSTALL_K3S_EXEC="server \
	--node-ip ${SERVER_IP} \
	--tls-san ${SERVER_IP}" sh -

# get join token for worker node
sudo cat /var/lib/rancher/k3s/server/node-token | sudo tee /vagrant/k3s-node-token >/dev/null
sudo chmod 644 /vagrant/k3s-node-token

# Optional: make kubectl usable for vagrant user without sudo
mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

# Optional: replace 127.0.0.1 in kubeconfig so kubectl uses the static server IP
sed -i "s/127.0.0.1/${SERVER_IP}/" /home/vagrant/.kube/config

# Quick sanity check
sudo kubectl get nodes || true
