#!/bin/bash

#time info
time=$(date +"%T %z")

echo $time

#uptime
uptime=$(uptime | awk -F ' ' '{print $3}')
printf "Uptime\n_______\n%s Minutes\n\n" "$uptime"

version=$(uname -a)
printf "Version\n_______\n%s\n\n" "version"

cpuinfo=$(cat /proc/cpuinfo)
printf "CPU Information\n_______\n%s\n\n" "$cpuinfo"

meminfo=$(cat /proc/meminfo | grep "MemTotal:")
printf "Memory Information\n_______\n%s\n\n" "$meminfo"

diskinfo=$(fdisk -l)
printf "Disk Information\n_______\n%s\n\n" "$diskinfo"

domain=$(echo `uname -n`.`awk '/^domain/ {print $2}' /etc/resolv.conf`)
printf "Domain Information\n_______\n%s\n\n" "$domain"

printf "User Information\n_______\n"
for i in $( awk -F ':' '{print $1}' /etc/passwd ); do
	id $i
done

services=$(service --status-all)
printf "Service Information\n_______\n%s\n\n" "$services"

arp=$(arp -a)
netconifg=$(ifconfig)
dhcpserver=$(cat /var/lib/dhcp/dhclient.eth0.leases | grep "fixed-address" | awk '{print $2}')
dnsserver=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}')
connections=$(netstat -tulpan)

printf "Arp Information\n_______\n%s\n\n" "$arp"
printf "Network Configuration\n_______\n%s\n\n" "$netconfig"
printf "DHCP Server Information\n_______\n%s\n\n" "$dhcpserver"
printf "DNS Server Information\n_______\n%s\n\n" "$dnsserver"
printf "Connections\n_______\n%s\n\n" "$connections"

processes=$(ps -aux)
printf "Processes\n_______\n%s\n\n" "$processes"

kmodules=$(find /lib/modules/$(uname -r) -type f -name '*.ko' | awk '{print $1}')
printf "Kernel Modules\n_______\n%s\n\n" "$kmodules"
