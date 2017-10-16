#!/bin/bash

for vpn in /proc/sys/net/ipv4/conf/*; do echo 0 > $vpn/accept_redirects; echo 0 > $vpn/send_redirects; done

local_gw=`ip route list default |head -n1 |cut -d ' ' -f3`
vpn_gw=`cat /var/log/syslog |grep 'PUSH: Received control message' |grep 'route-gateway' |tail -n1 |sed 's/.*route-gateway //' |cut -d ',' -f1`

# Ipredator tun0 routing
ip route add $trusted_ip via $local_gw
ip route flush table def
ip route add default via $vpn_gw table def
ip rule add from $ifconfig_local lookup def

ip route flush table vpn
ip route show table main | grep -Ev ^default | while read ROUTE ; do ip route add table vpn $ROUTE; done
ip route add default via $ifconfig_local dev tun0 table vpn
