#!/bin/bash

echo -e "\nListing the rules with the legacy iptables command\n"
sudo iptables -L -nv --line-numbers

echo -e "\nListing the rules with the new nft command\n"
sudo nft list ruleset

echo -e "\nListing the rules with the new nft command in human readable format\n"
sudo nft list ruleset human

echo -e "\nFlushing the rules with the new nft command\n"
sudo nft flush ruleset