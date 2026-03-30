
#!/bin/bash

set -e

echo "=== Update package ==="
sudo dnf update -y -qq 1>/dev/null
sudo dnf upgrade -y -qq 1>/dev/null
echo "Done."



echo "=== Disabling Swap file ==="
sudo swapoff -a 
sudo sed -i '/ swap / s/^/#/' /etc/fstab
echo "Done."

echo "=== Install Curl ==="
sudo dnf install -y -qq curl 1>/dev/null
echo "Done."

echo "=== Install Vim ==="
sudo dnf install -y -qq vim 1>/dev/null
echo "Done."

echo "=== Install Net Tools ==="
sudo dnf install -y -qq net-tools 1>/dev/null
echo "Done."

echo "=== Install k9s Tools ==="
if test -f k9s_linux_amd64.rpm; then
    echo "k9s already installed"
else
	curl -LO https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.rpm
	sudo dnf install -y -qq ./k9s_linux_amd64.rpm 1>/dev/null
fi
mkdir -p ~/.kube
echo "Done."

echo "=== Common Script Done ==="
