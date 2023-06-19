#!/usr/bin/php -q
<?php

$docroot = $docroot ?? $_SERVER['DOCUMENT_ROOT'] ?: '/usr/local/emhttp';

$notify = "{$docroot}/webGui/scripts/notify";

exec("tailscale status --json", $out_status);
$status = json_decode(implode($out_status));

if (isset($status->Self->KeyExpiry)) {
    $expiryTime = new DateTime($status->Self->KeyExpiry);
    $expiryTime->setTimezone(new DateTimeZone(date_default_timezone_get()));
    $interval = $expiryTime->diff(new DateTime('now'));

    $expiryPrint   = $expiryTime->format(DateTimeInterface::RFC7231);
    $intervalPrint = $interval->format('%a');

    $message = "The Tailscale key will expire in {$intervalPrint} days on {$expiryPrint}.";
    echo($message);

    switch (true) {
        case $interval->days <= 7:
            $priority = 'alert';
            break;
        case $interval->days <= 30:
            $priority = 'warning';
            break;
        default:
            exit;
    }

    $event = "Tailscale Key Expiration - {$priority} - {$expiryTime->format('Ymd')}";
    echo("Sending notification for key expiration: {$event}");

    $command = "{$notify} -l '/Settings/Tailscale' -e " . escapeshellarg($event) . " -s " . escapeshellarg("Tailscale key is expiring") . " -d " . escapeshellarg("{$message}") . " -i \"{$priority}\" -x 2>/dev/null";
    exec($command);
} else {
    echo("Tailscale key expiration is not set.");
}
