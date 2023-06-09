#!/usr/bin/php -q
<?php

include("include/common.php");

// Log current settings
foreach($tailscale_config as $key => $value) {
  logmsg("Setting: $key: $value");
}

include("include/set-tailscale-interface.php");

?>
