#!/bin/bash
rm ~/machinekit/configs/autorun
cd ..
ln -s "$(pwd)" ~/machinekit/configs/autorun
cd ~/machinekit/configs
echo 
echo "The new target should point to the configuration directory. It now points to:"
readlink -f autorun
