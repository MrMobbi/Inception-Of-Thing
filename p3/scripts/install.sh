
#!/bin/bash
set -e

# Colord
RED='\e[31m'
GREEN='\e[32m' 
BLUE='\e[34m'
RESET='\e[0m'

echo -e "${BLUE}=== Install k3d framwork ===${RESET}"
if test -f /usr/local/bin/k3d; then
	echo -e "${GREEN}Already installed${RESET}"
else
	curl curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.8.3 bash 1>/dev/null
fi
echo -e "${GREEN}Done.${RESET}"

echo -e "${BLUE}=== Install Snap framwork ===${RESET}"
if test -f /usr/bin/snap; then
	echo -e "${GREEN}Already installed${RESET}"
else
	apt install snap 1>/dev/null
fi
echo -e "${GREEN}Done.${RESET}"

echo -e "${BLUE}=== Install kubectl framwork ===${RESET}"
if test -f /usr/local/bin/kubectl; then
	echo -e "${GREEN}Already installed${RESET}"
else
	snap install kubectl --classic 1>/dev/null
fi
echo -e "${GREEN}Done.${RESET}"

echo -e "${BLUE}=== Install Docker framwork ===${RESET}"
if test -f /usr/bin/docker; then
	echo -e "${GREEN}Already installed${RESET}"
else
	apt install -y ca-certificates curl gnupg
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
	chmod a+r /etc/apt/keyrings/docker.asc
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null
	apt update
	apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi
echo -e "${GREEN}Done.${RESET}"

echo -e "${BLUE}=== Install openssl framwork ===${RESET}"
if test -f /usr/bin/openssl; then
	echo -e "${GREEN}Already installed${RESET}"
else
	apt install openssl 1>/dev/null
fi
echo -e "${GREEN}Done.${RESET}"
