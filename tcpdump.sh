#!/bin/bash

echo -e "\nSniff all traffic in the default interface (first non loopback, limited to 20 packets)\n"
sudo tcpdump -c 20 -n

echo -e "\nSniff all traffic including the payload (useless for HTTPS)\n"
sudo tcpdump -c 20 -n -A

echo -e "\nSniff all traffic filtering by interface, TCP protocol and port (limited to 20 packets)\n"
sudo tcpdump -i wlp0s20f3 -c 20 -n -A -vv tcp port 80

echo -e "\nSniff all traffic in the Wi-Fi interface (limited to 20 packets)\n"
sudo tcpdump -i wlp0s20f3 -c 20 -n

echo -e "\nSniff all traffic in the Immfly VPN interface (limited to 20 packets)\n"
sudo tcpdump -i tun0 -c 20 -n

echo -e "\nSaving the result into a file (also limited)\n"
sudo tcpdump -i tun0 -c 20 -n -w /tmp/capture.pcap

echo -e "\Reading the result from the file (it's libpcap format)\n"
tcpdump -r /tmp/capture.pcap