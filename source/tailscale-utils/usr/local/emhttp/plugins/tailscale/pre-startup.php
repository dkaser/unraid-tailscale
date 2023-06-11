#!/usr/bin/php -q
<?php

require "include/common.php";

// Log current settings
foreach ($tailscale_config as $key => $value) {
    logmsg("Setting: {$key}: {$value}");
}

require "include/set-tailscale-interface.php";
