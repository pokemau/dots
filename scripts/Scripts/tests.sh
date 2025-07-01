#!/bin/bash
exec 200>/tmp/mytest.lock
flock -n 200 || { echo "locked!"; exit 1; }
echo "running"
sleep 5
