#! /bin/sh
sudo cp x11vnc.service /lib/systemd/

sudo rm /etc/systemd/system/x11vnc.service

sudo ln /lib/systemd/x11vnc.service /etc/systemd/system/x11vnc.service

sudo systemctl daemon-reload

sudo systemctl enable x11vnc.service

sudo systemctl start x11vnc.service

# sleep 10

# sudo systemctl status x11vnc.service
