#!/bin/bash
if [ "$1" == "" -o "$2" == "" ] ; then
  echo "Usage: $0 <host> <user>"
  exit 0
fi

if [ "`which sshpass`" == "" ] ; then
  echo "sshpass not found, please install it from macports or homebrew."
  exit 1
fi

echo "[server]
$1  ansible_user=$2 ansible_port=22
" > inventory

echo "Ansible inventory created."
