#!/usr/bin/php -q
<?php

require "include/common.php";

$version = parse_ini_file('/etc/unraid-version');

// Log current settings
foreach ($tailscale_config as $key => $value) {
    logmsg("Setting: {$key}: {$value}");
}
if ($configure_extra_interfaces) {
    require "include/set-tailscale-interface.php";
}
if ($version['version'] == "6.12.0") {
    logmsg("Unraid 6.12.0: Checking SSH startup script");
    $ssh = file_get_contents('/etc/rc.d/rc.sshd');

    if (str_contains($ssh, '$family')) {
        logmsg("Unraid 6.12.0: Repairing SSH startup script");
        $ssh = str_replace('$family', 'any', $ssh);
        file_put_contents('/etc/rc.d/rc.sshd', $ssh);
    }
}
