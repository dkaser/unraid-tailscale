#!/bin/bash

TS_PLUGIN_CONFIG=/boot/config/plugins/tailscale/tailscale.cfg

if [ -f $TS_PLUGIN_CONFIG ]; then
    source $TS_PLUGIN_CONFIG
fi

if [[ $SYSCTL_IP_FORWARD ]]; then
    echo Enabling IP Forwarding

    echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-tailscale.conf
    echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.d/99-tailscale.conf
    sysctl -p /etc/sysctl.d/99-tailscale.conf 
fi

if [[ $TAILDROP_DIR && -d "$TAILDROP_DIR" && -x "$TAILDROP_DIR" ]]; then
    echo Configuring Taildrop

    if [ ! -d "/volume1" ]; then
        mkdir /volume1
    fi

    ln -sfn "$TAILDROP_DIR" /volume1/Taildrop
    export TS_DISABLE_TAILDROP=0
else
    echo Taildrop not configured or share not available, disabling
    export TS_DISABLE_TAILDROP=1
fi

/etc/rc.d/rc.tailscale restart
