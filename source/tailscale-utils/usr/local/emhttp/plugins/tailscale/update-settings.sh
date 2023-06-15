#!/bin/bash

TS_PLUGIN_CONFIG=/boot/config/plugins/tailscale/tailscale.cfg
TS_PLUGIN_ROOT=/usr/local/emhttp/plugins/tailscale

log() {
    echo "$1"
    logger -t unraid-tailscale "$1"
}

# Cleanup Taildrop emulation from pre-1.42.0
if [ ! -s /etc/config/uLinux.conf ] && [ -f /etc/config/uLinux.conf ]; then
    log "Cleaning up Taildrop emulation"
    rm /etc/config/uLinux.conf
fi

if [ ! -d /boot/config/plugins/tailscale/state ] && [ ! -f $TS_PLUGIN_CONFIG ]; then
    log "No state or config file, copying default configuration"
    cp $TS_PLUGIN_ROOT/tailscale.cfg.default $TS_PLUGIN_CONFIG
fi

log "Running pre-startup script"
$TS_PLUGIN_ROOT/pre-startup.php

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

sleep 60

case "$ACCEPT_ROUTES" in
'0')
    tailscale set --accept-routes=false
    log "tailscale set --accept-routes=false"
    ;;
'1')
    tailscale set --accept-routes=true
    log "tailscale set --accept-routes=true"
    ;;
*)
    log "Ignoring accept-routes"
esac

case "$ACCEPT_DNS" in
'0')
    tailscale set --accept-dns=false
    log "tailscale set --accept-dns=false"
    ;;
'1')
    tailscale set --accept-dns=true
    log "tailscale set --accept-dns=true"
    ;;
*)
    log "Ignoring accept-dns"
esac

log "Running post-startup script"
$TS_PLUGIN_ROOT/post-startup.php