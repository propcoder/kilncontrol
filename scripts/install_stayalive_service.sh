#! /bin/sh
sudo systemctl stop stayalive.service
sudo cp stayalive.service /lib/systemd/
sudo rm /etc/systemd/system/stayalive.service

sudo ln /lib/systemd/stayalive.service /etc/systemd/system/stayalive.service

sudo systemctl daemon-reload

sudo systemctl start stayalive.service

sleep 3

sudo systemctl status stayalive.service

sudo systemctl enable stayalive.service
