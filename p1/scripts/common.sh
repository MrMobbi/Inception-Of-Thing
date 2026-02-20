
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

echo "=== Common Script Done ==="
