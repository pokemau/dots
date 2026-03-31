#!/bin/bash


currBatt="$(bat-asus-battery threshold)"


if [[ $currBatt -eq 100 ]]; then
  echo "swap to 80"
  sudo bat-asus-battery threshold 80
else
  echo "swap to 100"
  sudo bat-asus-battery threshold 100
fi

sudo bat-asus-battery persist

# echo $currBatt
