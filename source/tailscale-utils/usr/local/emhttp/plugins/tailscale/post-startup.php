#!/usr/bin/php -q
<?php

require "include/common.php";

logmsg("Restarting Unraid services");
exec('/usr/local/emhttp/webGui/scripts/reload_services');
