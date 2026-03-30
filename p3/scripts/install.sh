
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
