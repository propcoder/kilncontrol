#! /bin/sh
sudo cp mkitapp.service /lib/systemd/
#sudo cp mklauncher.service /lib/systemd/

sudo rm /etc/systemd/system/mkitapp.service
#sudo rm /etc/systemd/system/mklauncher.service

sudo ln /lib/systemd/mkitapp.service /etc/systemd/system/mkitapp.service
#sudo ln /lib/systemd/mklauncher.service /etc/systemd/system/mklauncher.service

sudo systemctl daemon-reload

sudo systemctl enable mkitapp.service
#sudo systemctl enable mklauncher.service

sudo systemctl start mkitapp.service
#sudo systemctl start mklauncher.service

# sleep 10

# sudo systemctl status mkitapp.service
# sudo systemctl status mklauncher.service
