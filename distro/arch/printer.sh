#!/bin/bash

yay -S cups gutenprint cups-pdf gtk3-print-backends nmap \
system-config-printer sane-airscan simple-scan

sudo systemctl enable cups.service
sudo systemctl start cups.service

reboot

get_printer_ip() {
    ip addr show | awk '/^[0-9]+: wlp1s[0-9]/,/^$/{ if ($1 == "inet") \
        {print $2} }' | cut -d/ -f1 | sed 's/\(192\.168\.\)1\(\.5\)/\10\2/'
}

setup_printer() {

    printer_ip=get_printer_ip

#     type ip addr show
#     use inet to find your printer with nmap: sudo nmap -sP
#     sudo nmap -sP 192.168.1.[0]/24

#     Nmap scan report for 192.168.1.37
#     Host is up (0.11s latency).
#     MAC Address: E0:BB:9E:E2:79:D6 (Seiko Epson)
#
#     open system-config-printer (print settings)
#     choose epson L310
}

