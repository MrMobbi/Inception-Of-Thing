
#!/bin/bash

set -euxo pipefail

swapoff -a || true
sed -i '\/sswap\s/s/^/#/' /etc/fstab || true

apt-get update -y
apt-get install -y curl ca-certificates
