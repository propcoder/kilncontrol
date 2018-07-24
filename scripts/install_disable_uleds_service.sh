#! /bin/sh
sudo rm /usr/bin/disable_uleds.sh
sudo cp disable_uleds.sh /usr/bin/

sudo cp disable_uleds.service /lib/systemd/

sudo rm /etc/systemd/system/disable_uleds.service

sudo ln /lib/systemd/disable_uleds.service /etc/systemd/system/disable_uleds.service

sudo systemctl daemon-reload

sudo systemctl start disable_uleds.service

sleep 10

sudo systemctl status disable_uleds.service

sudo systemctl enable disable_uleds.service