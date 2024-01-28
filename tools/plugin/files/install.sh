if [ -d "{{ pluginDirectory }}" ]; then
    rm -rf {{ pluginDirectory }}
fi

upgradepkg --install-new {{ configDirectory }}/unraid-plugin-diagnostics-{{ diagVersion }}-noarch-1.txz
upgradepkg --install-new --reinstall {{ configDirectory }}/unraid-tailscale-utils-{{ packageVersion }}-noarch-1.txz

mkdir -p {{ pluginDirectory }}/bin
tar xzf {{ configDirectory }}/{{ tailscaleVersion }}.tgz --strip-components 1 -C {{ pluginDirectory }}/bin

ln -s {{ pluginDirectory }}/bin/tailscale /usr/local/sbin/tailscale
ln -s {{ pluginDirectory }}/bin/tailscaled /usr/local/sbin/tailscaled

mkdir -p /var/local/emhttp/plugins/tailscale
echo "VERSION={{ version }}" > /var/local/emhttp/plugins/tailscale/tailscale.ini
echo "BRANCH={{ branch }}" >> /var/local/emhttp/plugins/tailscale/tailscale.ini

# remove other branches (e.g., if switching from main to preview)
{% if branch != 'main' -%}
rm -f /boot/config/plugins/tailscale.plg
rm -f /var/log/plugins/tailscale.plg
{% endif -%}
{% if branch != 'preview' -%}
rm -f /boot/config/plugins/tailscale-preview.plg
rm -f /var/log/plugins/tailscale-preview.plg
{% endif -%}
{% if branch != 'trunk' -%}
rm -f /boot/config/plugins/tailscale-trunk.plg
rm -f /var/log/plugins/tailscale-trunk.plg
{% endif %}

{% if branch != 'main' -%}
# Update plugin name for non-main branches
sed -i "s/Tailscale\*\*/Tailscale ({{ branch.capitalize() }})**/" {{ pluginDirectory }}/README.md
{% endif %}

# start tailscaled
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