if [ -d "{{ pluginDirectory }}" ]; then
    rm -rf {{ pluginDirectory }}
fi

upgradepkg --install-new {{ configDirectory }}/unraid-plugin-diagnostics-{{ diagVersion }}-noarch-1.txz
upgradepkg --install-new --reinstall {{ configDirectory }}/unraid-tailscale-utils-{{ packageVersion }}-noarch-1.txz

mkdir -p {{ pluginDirectory }}/bin
tar xzf {{ configDirectory }}/{{ tailscaleVersion }}.tgz --strip-components 1 -C {{ pluginDirectory }}/bin

ln -s {{ pluginDirectory }}/bin/tailscale /usr/local/sbin/tailscale
ln -s {{ pluginDirectory }}/bin/tailscaled /usr/local/sbin/tailscaled

# start tailscaled
echo "starting tailscaled..."
{{ pluginDirectory }}/restart.sh

# cleanup old versions
rm -f /boot/config/plugins/{{ name }}/tailscale-utils-*.txz
rm -f $(ls /boot/config/plugins/{{ name }}/unraid-tailscale-utils-*.txz 2>/dev/null | grep -v '{{ packageVersion }}')
rm -f $(ls /boot/config/plugins/{{ name }}/unraid-plugin-diagnostics-*.txz 2>/dev/null | grep -v '{{ diagVersion }}')
rm -f $(ls /boot/config/plugins/{{ name }}/*.tgz 2>/dev/null | grep -v '{{ tailscaleVersion }}')

echo ""
echo "----------------------------------------------------"
echo " {{ name }} has been installed."
echo " Version: {{ version }}"
echo "----------------------------------------------------"
echo ""