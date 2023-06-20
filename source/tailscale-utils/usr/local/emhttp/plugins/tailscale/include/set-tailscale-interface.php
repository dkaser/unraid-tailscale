<?php

$include_array      = array();
$exclude_interfaces = "";
$write_file         = true;

if (file_exists($network_extra_file)) {
    extract(parse_ini_file($network_extra_file));
    if ($include_interfaces) {
        $include_array = explode(' ', $include_interfaces);
    }
    $write_file = false;
}

$in_array = in_array($ifname, $include_array);

if ($in_array != $tailscale_config["INCLUDE_INTERFACE"]) {
    if ($tailscale_config["INCLUDE_INTERFACE"]) {
        $include_array[] = $ifname;
        logmsg("{$ifname} added to include_interfaces", LOG_NOTICE);
    } else {
        $include_array = array_diff($include_array, [$ifname]);
        logmsg("{$ifname} removed from include_interfaces", LOG_NOTICE);
    }
    $write_file = true;
}

if ($write_file) {
    $include_interfaces = implode(' ', $include_array);

    $file = <<<END
        include_interfaces="{$include_interfaces}"
        exclude_interfaces="{$exclude_interfaces}"

        END;

    file_put_contents($network_extra_file, $file);
    logmsg("Updated network-extra.cfg", LOG_NOTICE);
}
