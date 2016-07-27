#!/usr/bin/env bash
# Tzach Shefi, July27 2016.
# created this script to expand template/image of rhel to full disk space.
# Script to create sdb on remaining free space, and vgextend into it.
# crontab ->   @reboot     /root/golden.sh

spart=$(parted /dev/sda print free | grep 'Free Space' | tail -n 1 | awk '{print $1}')
parted /dev/sda mkpart primary $spart 100%
unset spart
partprobe
vgextend vg0 /dev/sda3
lvextend /dev/vg0/lv_root -r -l 30%FREE
lvextend /dev/vg0/lv_home -r -l +100%FREE

#set hostname
# sleep for DHclient to get an IP before this runs.
sleep 60s

hostnamectl set-hostname dhcp$(ip route | grep src | awk '{print$9}' |  cut -d . -f 3)-$(ip route | grep src | awk '{print$9}' |  cut -d . -f 4).scl.lab.tlv.redhat.com

echo $date > /root/goldenrun.txt

#If I add this in crontab, don't forget to remove it!