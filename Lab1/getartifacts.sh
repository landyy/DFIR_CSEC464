#!/bin/bash
#By: Russell Babarsky
#Gets various information based around the system and prints it into an easily readable format with tables
#Also has the option to export to csv

#time info
time=$(date +"%T %z")
printf "Time\n_______\n%s Minutes\n\n" "$time"

#get the uptime of the system
uptime=$(uptime | awk -F ' ' '{print $3}')
printf "Uptime\n_______\n%s Minutes\n\n" "$uptime"

#get version information of the system
version=$(uname -a)
printf "Version\n_______\n%s\n\n" "version"

#Get cpu information of the system
cpuinfo=$(cat /proc/cpuinfo)
printf "CPU Information\n_______\n%s\n\n" "$cpuinfo"

#Gets memory info from /proc
meminfo=$(cat /proc/meminfo | grep "MemTotal:")
printf "Memory Information\n_______\n%s\n\n" "$meminfo"

#Gets the disk information
diskinfo=$(fdisk -l)
printf "Disk Information\n_______\n%s\n\n" "$diskinfo"

#Gets the domain information on linux systems
domain=$(echo `uname -n`.`awk '/^domain/ {print $2}' /etc/resolv.conf`)
printf "Domain Information\n_______\n%s\n\n" "$domain"

#loops through /etc/passwd and gets all the users on the system
printf "User Information\n_______\n"
for i in $( awk -F ':' '{print $1}' /etc/passwd ); do
	id $i
done

#Gets logins the are seen by PAM
printf "\n"
auth=$(cat /var/log/auth.log | grep pam_unix)
printf "Auth Information\n_______\n%s\n\n" "$auth"

#Installed software on the system
bin=$(ls -l /bin | awk '{print $9}')
usrbin=$(ls -l /usr/bin | awk '{print $9}')
printf "Insatlled Programs\n_______\n%s\n\n" "$usrbin" "$bin"

#Gets all services on the system
services=$(service --status-all)
printf "Service Information\n_______\n%s\n\n" "$services"

#Gets networking information
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

#Gets processes on the host
processes=$(ps -aux)
printf "Processes\n_______\n%s\n\n" "$processes"

#gets kernel moules information
kmodules=$(find /lib/modules/$(uname -r) -type f -name '*.ko' | awk '{print $1}')
printf "Kernel Modules\n_______\n%s\n\n" "$kmodules"

#Get files that have the sticky bit set
sticky=$(find / -perm -1000 -type d 2>/dev/null)

# 
