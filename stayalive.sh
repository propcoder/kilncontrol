#!/bin/bash
while true; do
	if [ "`fping vpn.robotise.lt`" != "vpn.robotise.lt is alive" ]
	then
	        # iwconfig eth1 essid linksys key open
		# ifdown enp4s0
		# ifup enp4s0
		# /etc/init.d/networking restart
	        # dhclient enp4s0
		echo "networking restart"
		ifconfig enp4s0 down
		sleep 10
		ifconfig enp4s0 up
		service networking restart
	fi
	sleep 5
    if [ "`fping 10.10.0.1`" != "10.10.0.1 is alive" ]
    then
        echo "OpenVPN restart"
        ifconfig enp4s0 down
        sleep 5
        ifconfig enp4s0 up
        sleep 5
        service network-manager restart
        service openvpn restart
    fi
	sleep 60
done
