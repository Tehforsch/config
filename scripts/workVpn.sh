#!/usr/bin/env bash

# VPN connection script
# Usage: ./workVpn.sh start|stop

CONFIG_FILE="$HOME/resource/keys/vpns/work_vpn.json"
PID_FILE="$HOME/.cache/workVpn.pid"

# Parse JSON config
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

VPN_HOST=$(jq -r '.work.host' "$CONFIG_FILE")
VPN_USER=$(jq -r '.work.username' "$CONFIG_FILE")
VPN_GROUP=$(jq -r '.work.group' "$CONFIG_FILE")
VPN_PASSWORD=$(jq -r '.work.password' "$CONFIG_FILE")
VPN_GROUP_PASSWORD=$(jq -r '.work.group_password' "$CONFIG_FILE")
VPN_PROTOCOL=$(jq -r '.work.protocol' "$CONFIG_FILE")

if [[ "$VPN_HOST" == "null" || "$VPN_USER" == "null" || "$VPN_PASSWORD" == "null" ]]; then
    echo "Error: Missing required fields in config file"
    exit 1
fi

start_vpn() {
    if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "VPN is already running (PID: $(cat "$PID_FILE"))"
        exit 1
    fi


    echo "Starting VPN connection to $VPN_HOST..."
    
    # Use password from JSON config
    echo "$VPN_PASSWORD" | sudo openconnect \
        --protocol="$VPN_PROTOCOL" \
        --user="$VPN_USER" \
        --passwd-on-stdin \
        --background \
        --pid-file="$PID_FILE" \
        "$VPN_HOST"

    if [[ $? -eq 0 ]]; then
        echo "VPN started successfully (PID: $(cat "$PID_FILE"))"
    else
        echo "Failed to start VPN"
        exit 1
    fi
}

stop_vpn() {
    # First try to find openconnect process for our VPN
    local pid=$(pgrep -f "openconnect.*$VPN_HOST")
    
    if [[ -n "$pid" ]]; then
        echo "Stopping VPN (PID: $pid)..."
        sudo kill "$pid"
        rm -f "$PID_FILE"
        echo "VPN stopped"
    elif [[ -f "$PID_FILE" ]]; then
        local file_pid=$(cat "$PID_FILE")
        if kill -0 "$file_pid" 2>/dev/null; then
            echo "Stopping VPN (PID: $file_pid)..."
            sudo kill "$file_pid"
        fi
        rm -f "$PID_FILE"
        echo "VPN stopped"
    else
        echo "VPN is not running"
        exit 1
    fi
}

case "$1" in
    start)
        start_vpn
        ;;
    stop)
        stop_vpn
        ;;
    status)
        pid=$(pgrep -f "openconnect.*$VPN_HOST")
        if [[ -n "$pid" ]]; then
            echo "VPN is running (PID: $pid)"
        else
            echo "VPN is not running"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac
