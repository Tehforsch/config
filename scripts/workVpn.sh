if [[ $(hostname) == thinkpad  || $(hostname) == framework ]]; then
    echo "Hi"
    sudo openconnect vpn.greenbone.net --protocol=gp
else
    nmcli con up id "Greenbone VPN"
    sudo ip link set mtu 1380 dev gb-vpn
fi
