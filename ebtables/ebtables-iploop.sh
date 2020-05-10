#!/usr/bin/php
<?php

if (count($argv) != 3) {
    die("Bad arguments.\n");
}

$chain = $argv[1];
$ip = $argv[2];

$arpChain = shell_exec("ebtables -L arp-{$chain}");
if (!$arpChain) {
    shell_exec("ebtables -N arp-{$chain} -P ACCEPT");
    
    $arpChain = shell_exec("ebtables -L arp-{$chain}");

    if (!$arpChain) {
        die("Unable to find or create ARP chain.\n");
    }
}

if (strpos($arpChain, "-p ARP --arp-op Request --arp-ip-dst {$ip} -j ACCEPT") === false) {
    shell_exec("ebtables -I arp-{$chain} -p ARP --arp-op Request --arp-ip-dst {$ip} -j ACCEPT");

    $arpChain = shell_exec("ebtables -L arp-{$chain}");

    if (strpos($arpChain, "-p ARP --arp-op Request --arp-ip-dst {$ip} -j ACCEPT") === false) {
        die("Unable to add IPv4 ARP rule to ARP chain.\n");
    }
}

if (strpos($arpChain, "-p ARP --arp-op Request -j DROP") === false) {
    shell_exec("ebtables -A arp-{$chain} -p ARP --arp-op Request -j DROP");

    $arpChain = shell_exec("ebtables -L arp-{$chain}");

    if (strpos($arpChain, "-p ARP --arp-op Request -j DROP") === false) {
        die("Unable to add default DROP to ARP chain.\n");
    }
}

$forwardChain = shell_exec("ebtables -L FORWARD");
if (!$forwardChain) {
    die("Unable to find FORWARD chain.\n");
}

if (strpos($forwardChain, "-o {$chain} -j arp-{$chain}") === false) {
    shell_exec("ebtables -A FORWARD -o {$chain} -j arp-{$chain}");

    $forwardChain = shell_exec("ebtables -L FORWARD");
    if (strpos($forwardChain, "-o {$chain} -j arp-{$chain}") === false) {
        die("Unable to append to FORWARD chain.\n");
    }
}
