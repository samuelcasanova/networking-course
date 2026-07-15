#!/bin/bash

echo -e "\nQuery the IP (v4 by default) address of google\n"
nslookup google.com

echo -e "\nQuery the IP v6 address of google\n"
nslookup -query=AAAA google.com

echo -e "\nQuery in debug mode\n"
nslookup -debug google.com

echo -e "\nQuery using modern dig command (recommended most of the time)\n"
dig google.com

echo -e "\nQuery only the resolved IP (for scripting)\n"
dig +short google.com

echo -e "\nQuery using a DNS server directly, skipping the local systemd-resolved stub\n"
dig @8.8.8.8 google.com

echo -e "\nCheck resolver status on each interface\n"
resolvectl status

echo -e "\nFlush DNS cache\n"
resolvectl flush-caches