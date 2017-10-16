#!/bin/bash

# Masquerading is required for routing between the networks to work
/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
/sbin/iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

# Allow outbound connections
/sbin/iptables -A OUTPUT -o tun0 -p tcp -m tcp -j ACCEPT

# Allow packets for established connections
/sbin/iptables -A INPUT -i tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow inbound tcp/6881 on the tun0 (openvpn) interface
/sbin/iptables -A INPUT -i tun0 -p tcp -m tcp --dport 6881 -j ACCEPT

# Drop all other inbound connections on the tun0 (openvpn) interface
/sbin/iptables -A INPUT -i tun0 -p tcp -m tcp --syn -j DROP
