#!/bin/bash

echo -e "\nList all interfaces and their IP addresses\n"
ip addr show

echo -e "\nList only an interface\n"
ip addr show enp0s31f6

echo -e "\nList in brief format\n"
ip -brief addr

echo -e "\nShow all routing tables (rules)\n"
ip rule show

echo -e "\nShow the main routing table\n"
ip route

echo -e "\nShow all routing tables\n"
ip route show table all

echo -e "\nShow the default (not main) routing table, normally empty\n"
ip route show default

echo -e "\nShow the route to 8.8.8.8\n"
ip route get 8.8.8.8