#!/usr/bin/env bash

# Get the IP address of the main network interface
PC_IP=$(ip a | grep -E 'inet 192\.168\.' | head -1 | awk '{print $2}' | cut -d'/' -f1)

if [ -z "$PC_IP" ]; then
    echo "Could not determine PC IP address"
    exit 1
fi

echo "Using PC IP: $PC_IP"

# Create sources.xml with dynamic IP
sed "s/IP_ADDRESS/$PC_IP/g" sources.xml > /tmp/sources.xml
scp /tmp/sources.xml rpi2:/storage/.kodi/userdata/sources.xml
rm /tmp/sources.xml

# Create mediasources.xml with dynamic IP
sed "s/IP_ADDRESS/$PC_IP/g" mediasources.xml > /tmp/mediasources.xml
scp /tmp/mediasources.xml rpi2:/storage/.kodi/userdata/mediasources.xml
rm /tmp/mediasources.xml

# Create passwords.xml with SMB credentials and dynamic IP
cat > /tmp/passwords.xml << EOF
<passwords>
    <path>
        <from pathversion="1">smb://$PC_IP/</from>
        <to pathversion="1">smb://toni:$(cat ~/resource/keys/pw/samba)@$PC_IP/</to>
    </path>
</passwords>
EOF

scp /tmp/passwords.xml rpi2:/storage/.kodi/userdata/passwords.xml
rm /tmp/passwords.xml
