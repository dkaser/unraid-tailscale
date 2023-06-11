<?php

function getKeyExpirationWarning($status)
{
    if (isset($status->Self->KeyExpiry)) {
        $expiryTime = new DateTime($status->Self->KeyExpiry);
        $expiryTime->setTimezone(new DateTimeZone(date_default_timezone_get()));

        $interval      = $expiryTime->diff(new DateTime('now'));
        $expiryPrint   = $expiryTime->format(DateTimeInterface::RFC7231);
        $intervalPrint = $interval->format('%a');

        switch (true) {
            case $interval->days <= 7:
                $priority = 'error';
                break;
            case $interval->days <= 30:
                $priority = 'warn';
                break;
            default:
                $priority = 'system';
                break;
        }

        return "<span class='{$priority}' style='text-align: center; font-size: 1.4em; font-weight: bold;'>The Tailscale key will expire in {$intervalPrint} days on {$expiryPrint}.</span>";
    }
    return "";
}
