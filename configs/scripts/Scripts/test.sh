#!/bin/bash

err=0
ssid=$(nmcli -f 'bssid,in-use,signal,bars,freq,rate,security,ssid' \
    --color yes device wifi list --rescan yes \
    | fzf --ansi \
          --with-nth=2.. \
          --reverse \
          --cycle \
          --print-query \
          --header-lines=1 \
          --margin='1,2,1,2' \
          --color='16,gutter:-1' \
    | sed 's/^ *\*//' \
    | awk '{print $8}')  # Changed to extract the 8th field (SSID)
echo "Please wait while connecting to network $ssid…"
nmcli device wifi connect "$ssid" 2> /dev/null || err=1
if [[ "$err" = 1 ]]; then
  printf "SSID "
  nmcli -a device wifi connect "$ssid"
fi
printf "Press any key to close.\n" && read -n1
