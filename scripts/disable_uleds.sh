#!/bin/bash
echo none > /sys/class/leds/beaglebone\:green\:usr0/trigger
echo none > /sys/class/leds/beaglebone\:green\:usr1/trigger
echo none > /sys/class/leds/beaglebone\:green\:usr2/trigger
echo none > /sys/class/leds/beaglebone\:green\:usr3/trigger

# sudo chown machinekit /sys/class/leds/beaglebone\:green\:usr0/trigger
# sudo chown machinekit /sys/class/leds/beaglebone\:green\:usr1/trigger
# sudo chown machinekit /sys/class/leds/beaglebone\:green\:usr2/trigger
# sudo chown machinekit /sys/class/leds/beaglebone\:green\:usr3/trigger

# cd /sys/class/leds/beaglebone\:green\:usr0
