#!/bin/bash
echo "Restarting Tailscale in 5 seconds" | logger -t tailscaled
echo "sleep 5 ; /usr/local/emhttp/plugins/tailscale/update-settings.sh" | at now 2>/dev/null
