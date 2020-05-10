# ebtables ARP hook

This is a script designed to block ARP requests that have a destination IP not assigned to a particular KVM server.

# Installation

1. Ensure that the "IP Stealing" setting is enabled in SolusVM control panel
2. Copy the script to `/usr/local/solusvm/data/hooks/ebtables-iploop.sh`
3. `chmod +x /usr/local/solusvm/data/hooks/ebtables-iploop.sh`

# Limitations

- Currently rules and chains are not automatically removed if corresponding IP's/VM's are deleted.
