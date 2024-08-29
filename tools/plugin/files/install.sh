if [ -d "{{ pluginDirectory }}" ]; then
    rm -rf {{ pluginDirectory }}
fi

upgradepkg --install-new {{ configDirectory }}/unraid-plugin-diagnostics-{{ diagVersion }}-noarch-1.txz
upgradepkg --install-new --reinstall {{ configDirectory }}/unraid-tailscale-utils-{{ packageVersion }}-noarch-1.txz

mkdir -p {{ pluginDirectory }}/bin
tar xzf {{ configDirectory }}/{{ tailscaleVersion }}.tgz --strip-components 1 -C {{ pluginDirectory }}/bin

echo "state" > {{ configDirectory }}/.gitignore

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

# Bash completion
tailscale completion bash > /etc/bash_completion.d/tailscale

# cleanup old versions
rm -f /boot/config/plugins/{{ name }}/tailscale-utils-*.txz
rm -f $(ls /boot/config/plugins/{{ name }}/unraid-tailscale-utils-*.txz 2>/dev/null | grep -v '{{ packageVersion }}')
rm -f $(ls /boot/config/plugins/{{ name }}/unraid-plugin-diagnostics-*.txz 2>/dev/null | grep -v '{{ diagVersion }}')
rm -f $(ls /boot/config/plugins/{{ name }}/*.tgz 2>/dev/null | grep -v '{{ tailscaleVersion }}')

# check to see if the state file has been backed up to Unraid Connect
if [ -d "/boot/.git" ]; then
        if git --git-dir /boot/.git log --all --name-only --diff-filter=A -- config/plugins/tailscale/state/tailscaled.state | grep -q . ; then
            echo "******************************"
            echo "*          WARNING           *"
            echo "******************************"
            echo " "
            echo "The Tailscale state file has been backed up to Unraid Connect via Flash backup." 
            echo " "
            echo "To remove this backup, please perform the following steps:"
            echo "1. Go to Settings -> Management Access".
            echo "2. Under Unraid Connect, deactivate flash backup. Select the option to also delete cloud backup."
            echo "3. Reactivate flash backup."

            /usr/local/emhttp/webGui/scripts/notify -l '/Settings/ManagementAccess' -i 'alert' -e 'Tailscale State' -s 'Tailscale state backed up to Unraid connect.' -d 'The Tailscale state file has been backed up to Unraid connect. This is a potential security risk. From the Management Settings page, deactivate flash backup and delete cloud backups, then reactivate flash backup.'
        fi
fi

echo ""
echo "----------------------------------------------------"
echo " {{ name }} has been installed."
echo " Version: {{ version }}"
echo "----------------------------------------------------"
echo ""