#!/bin/bash

echo -e "\nList all interfaces and their IP addresses\n"
ip a
echo -e "\n\n List only interface links and statuses\n"
ip link show
# Disable an interface (bring it DOWN):
#sudo ip link set <interface_name> down
# Enable an interface (bring it UP):
#sudo ip link set <interface_name> up

echo -e "\n\n List all network devices and their status with nmcli\n"
nmcli device status