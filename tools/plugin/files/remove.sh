# Stop service
/etc/rc.d/rc.tailscale stop 2>/dev/null

rm /usr/local/sbin/tailscale
rm /usr/local/sbin/tailscaled

removepkg unraid-tailscale-utils-{{ packageVersion }}

rm -rf {{ pluginDirectory }}
rm -rf {{ configDirectory }}