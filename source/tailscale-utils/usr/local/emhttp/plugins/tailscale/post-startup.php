#!/usr/bin/php -q
<?php

include("include/common.php");

logmsg("Restarting Unraid services");
exec('/usr/local/emhttp/webGui/scripts/reload_services');

?>