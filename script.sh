#!/bin/bash

arc=$(uname -a)

ph_cpu=$(grep "physical id" /proc/cpuinfo | wc -l) 
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

total_ram=$(free -m | awk '$1 == "Mem:" {print $2}')
used_ram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free -m | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

total_disk=$(df -BG | grep '/dev/' | grep -v '/boot' | awk '{ft += $2} END {print ft}')
used_disk=$(df -BM | grep '/dev/' | grep -v '/boot' | awk '{ut += $3} END {print ut}')
pdisk=$(df -BM | grep '/dev/' | grep -v '/boot' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')

cpul=$(mpstat | tail -1 | awk '{printf"%.1f%%",100 - $NF}')

l_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

lvm_use=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

ctcp=$(ss -ta | grep ESTAB | wc -l)

u_log=$(users | wc -w)

ip=$(hostname -I)
mac=$(ip link show | grep "ether" | awk '{print $2}')
cmds=$(journalctl _COMM=sudo -q | grep COMMAND | wc -l)

wall "    #Architecture: $arc
    #CPU physical : $ph_cpu
    #vCPU : $vcpu
    #Memory Usage: $used_ram/${total_ram}MB ($pram%)
    #Disk Usage: $used_disk/${total_disk}Gb ($pdisk%)
    #CPU load: $cpul
    #Last boot: $l_boot
    #LVM use: $lvm_use
    #Connections TCP : $ctcp ESTABLISHED
    #User log: $u_log
    #Network: IP $ip ($mac)
    #Sudo : $cmds cmd"
