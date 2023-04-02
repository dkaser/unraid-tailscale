#!/bin/bash

source /boot/config/plugins/tailscale/tailscale.cfg

if [[ $SYSCTL_IP_FORWARD ]]; then
    echo Enabling IP Forwarding

    echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-tailscale.conf
    echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.d/99-tailscale.conf
    sysctl -p /etc/sysctl.d/99-tailscale.conf 
fi

if [[ $TAILDROP_DIR && -d "$TAILDROP_DIR" && -x "$TAILDROP_DIR" ]]; then
    echo Configuring Taildrop
    
    mkdir -p /etc/config
    touch /etc/config/uLinux.conf

    mkdir /share
    ln -s "$TAILDROP_DIR" /share/Taildrop
    export TS_DISABLE_TAILDROP=0
else
    echo Taildrop not configured or share not available, disabling
    if [ ! -s /etc/config/uLinux.conf ]; then
        rm /etc/config/uLinux.conf
    fi
    export TS_DISABLE_TAILDROP=1
fi

/etc/rc.d/rc.tailscale restart
