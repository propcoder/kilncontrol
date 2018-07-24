#! /bin/sh

sudo rm /etc/systemd/system/ping4on.service

sudo ln /lib/systemd/ping4on.service /etc/systemd/system/ping4on.service

sudo systemctl daemon-reload

sudo systemctl start ping4on.service

sleep 3

sudo systemctl status ping4on.service

sudo systemctl enable ping4on.service