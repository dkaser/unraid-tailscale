( cd etc/rc.d ; rm -rf rc.tailscale )
( cd etc/rc.d ; ln -sf /usr/local/emhttp/plugins/tailscale/rc.tailscale rc.tailscale )
( cd usr/local/emhttp/plugins/tailscale/event ; rm -rf array_started )
( cd usr/local/emhttp/plugins/tailscale/event ; ln -sf ../restart.sh array_started )
( cd usr/local/emhttp/plugins/tailscale/event ; rm -rf stopped )
( cd usr/local/emhttp/plugins/tailscale/event ; ln -sf ../restart.sh stopped )