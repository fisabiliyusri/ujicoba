#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Link Hosting Kalian Untuk SSH VPN
sla="raw.githubusercontent.com/fisabiliyusri/ujicoba/main/ssh"
# Link Hosting Kalian Untuk Websocket
slb="raw.githubusercontent.com/fisabiliyusri/ujicoba/main/websocket"

# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
rm -f setup.sh

# INSTALL BOSS

# Install SSH VPN
wget https://${sla}/install-ssh.sh && chmod +x install-ssh.sh && ./install-ssh.sh
# Install Websocket
wget https://${slb}/python.sh && chmod +x python.sh && ./python.sh

# INSTALL BOSS
rm -f /root/install-ssh.sh
rm -f /root/python.sh
