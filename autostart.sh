#!/bin/bash
killall mklauncher
if [ -f ~/machinekit/mkit-git/scripts/rip-environment ]; then
    source ~/machinekit/mkit-git/scripts/rip-environment
#     echo "Environment set up for running Machinekit"
fi
mklauncher ~/machinekit/configs/autorun &
x11vnc -R stop
x11vnc -bg -o %HOME/.x11vnc.log.%VNCDISPLAY -auth /var/run/lightdm/root/:0 -forever
