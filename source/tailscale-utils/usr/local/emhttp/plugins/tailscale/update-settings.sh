#!/bin/bash

TS_PLUGIN_CONFIG=/boot/config/plugins/tailscale/tailscale.cfg

log() {
  echo "$1"
  logger -t unraid-tailscale "$1"
}

# Cleanup Taildrop emulation from pre-1.42.0
if [ ! -s /etc/config/uLinux.conf ] && [ -f /etc/config/uLinux.conf ]; then
    log "Cleaning up Taildrop emulation"
    rm /etc/config/uLinux.conf
fi

if [ -f $TS_PLUGIN_CONFIG ]; then
    logger -t unraid-tailscale < $TS_PLUGIN_CONFIG
    source $TS_PLUGIN_CONFIG
fi

if [[ $SYSCTL_IP_FORWARD ]]; then
    log "Enabling IP Forwarding"

    echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-tailscale.conf
    echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.d/99-tailscale.conf
    sysctl -p /etc/sysctl.d/99-tailscale.conf 
fi

if [[ $TAILDROP_DIR && -d "$TAILDROP_DIR" && -x "$TAILDROP_DIR" ]]; then
    log "Configuring Taildrop link"

    if [ ! -d "/var/lib/tailscale" ]; then
        mkdir /var/lib/tailscale
    fi

    ln -sfn "$TAILDROP_DIR" /var/lib/tailscale/Taildrop
fi

/etc/rc.d/rc.tailscale restart
