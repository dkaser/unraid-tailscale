<?php

function printRow($title, $value)
{
    return "<tr><td>{$title}</td><td>{$value}</td></tr>" . PHP_EOL;
}

function getStatusInfo($status, $prefs)
{
    $tsVersion     = isset($status->Version) ? $status->Version : "Unknown";
    $keyExpiration = isset($status->Self->KeyExpiry) ? $status->Self->KeyExpiry : "Disabled";
    $online        = isset($status->Self->Online) ? ($status->Self->Online ? "Yes" : "No") : "Unknown";
    $inNetMap      = isset($status->Self->InNetworkMap) ? ($status->Self->InNetworkMap ? "Yes" : "No") : "Unknown";
    $tags          = isset($status->Self->Tags) ? implode("<br />", $status->Self->Tags) : "";
    $loggedIn      = isset($prefs->LoggedOut) ? ($prefs->LoggedOut ? "No" : "Yes") : "Unknown";
    $tsHealth      = isset($status->Health) ? implode("<br />", $status->Health) : "";

    $output = "";
    $output .= printRow("Tailscale Version", $tsVersion);
    $output .= printRow("Tailscale Health", $tsHealth);
    $output .= printRow("Logged In", $loggedIn);
    $output .= printRow("In Network Map", $inNetMap);
    $output .= printRow("Online", $online);
    $output .= printRow("Key Expiration", $keyExpiration);
    $output .= printRow("Tags", $tags);

    return $output;
}

function getConnectionInfo($status, $prefs)
{
    $hostName         = isset($status->Self->HostName) ? $status->Self->HostName : "Unknown";
    $dnsName          = isset($status->Self->DNSName) ? $status->Self->DNSName : "Unknown";
    $tailscaleIPs     = isset($status->TailscaleIPs) ? implode("<br />", $status->TailscaleIPs) : "Unknown";
    $magicDNSSuffix   = isset($status->MagicDNSSuffix) ? $status->MagicDNSSuffix : "Unknown";
    $advertisedRoutes = isset($prefs->AdvertiseRoutes) ? implode("<br />", $prefs->AdvertiseRoutes) : "None";
    $acceptRoutes     = isset($prefs->RouteAll) ? ($prefs->RouteAll ? "Yes" : "No") : "Unknown";
    $acceptDNS        = isset($prefs->CorpDNS) ? ($prefs->CorpDNS ? "Yes" : "No") : "Unknown";

    $output = "";
    $output .= printRow("Hostname", $hostName);
    $output .= printRow("DNS Name", $dnsName);
    $output .= printRow("Tailscale IPs", $tailscaleIPs);
    $output .= printRow("MagicDNS Suffix", $magicDNSSuffix);
    $output .= printRow("Advertised Routes", $advertisedRoutes);
    $output .= printRow("Accept Routes", $acceptRoutes);
    $output .= printRow("Accept DNS", $acceptDNS);

    return $output;
}
