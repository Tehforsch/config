#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Get the IP address of the main network interface
PC_IP=$(ip a | grep -E 'inet 192\.168\.' | head -1 | awk '{print $2}' | cut -d'/' -f1)

if [ -z "$PC_IP" ]; then
    echo "Could not determine PC IP address"
    exit 1
fi

echo "Using PC IP: $PC_IP"

TMP_SOURCES=$(mktemp)
TMP_MEDIASOURCES=$(mktemp)
TMP_PASSWORDS=$(mktemp)
trap 'rm -f "$TMP_SOURCES" "$TMP_MEDIASOURCES" "$TMP_PASSWORDS"' EXIT

# Create sources.xml with dynamic IP
sed "s/IP_ADDRESS/$PC_IP/g" "$SCRIPT_DIR/sources.xml" > "$TMP_SOURCES"
scp "$TMP_SOURCES" rpi2:/storage/.kodi/userdata/sources.xml

# Create mediasources.xml with dynamic IP
sed "s/IP_ADDRESS/$PC_IP/g" "$SCRIPT_DIR/mediasources.xml" > "$TMP_MEDIASOURCES"
scp "$TMP_MEDIASOURCES" rpi2:/storage/.kodi/userdata/mediasources.xml

# Create passwords.xml with SMB credentials and dynamic IP
cat > "$TMP_PASSWORDS" << EOF
<passwords>
    <path>
        <from pathversion="1">smb://$PC_IP/</from>
        <to pathversion="1">smb://toni:$(cat ~/resource/keys/pw/samba)@$PC_IP/</to>
    </path>
</passwords>
EOF

scp "$TMP_PASSWORDS" rpi2:/storage/.kodi/userdata/passwords.xml
