#!/bin/bash

ip rule del from $ifconfig_local
ip route flush table def
ip route flush table vpn
ip route del $trusted_ip
