#!/bin/bash

swww query &> /dev/null
if [ $? -ne 0 ] ; then
    swww-daemon --format xrgb
fi
