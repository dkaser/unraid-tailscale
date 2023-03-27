#!/bin/bash

source /boot/config/plugins/tailscale/tailscale.cfg

if [[ $SYSCTL_IP_FORWARD ]]; then
    echo Enabling IP Forwarding

    echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
    echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
    sysctl -p /etc/sysctl.d/99-tailscale.conf 
fi