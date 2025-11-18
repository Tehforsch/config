#!/usr/bin/env bash

# Interactive VPN connection script

CONFIG_FILE="$HOME/resource/keys/vpns/work_vpn.json"

# Parse JSON config
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

VPN_HOST=$(jq -r '.work.host' "$CONFIG_FILE")
VPN_USER=$(jq -r '.work.username' "$CONFIG_FILE")
VPN_GROUP=$(jq -r '.work.group' "$CONFIG_FILE")
VPN_PROTOCOL=$(jq -r '.work.protocol' "$CONFIG_FILE")
VPN_PASSWORD=$(jq -r '.work.password' "$CONFIG_FILE")

if [[ "$VPN_HOST" == "null" || "$VPN_USER" == "null" ]]; then
    echo "Error: Missing required fields in config file"
    exit 1
fi

echo "Starting interactive VPN connection to $VPN_HOST..."

echo "$VPN_PASSWORD" | sudo openconnect \
    --passwd-on-stdin \
    --protocol="$VPN_PROTOCOL" \
    --user="$VPN_USER" \
    --authgroup="$VPN_GROUP" \
    --mtu=1380 \
    "$VPN_HOST"
