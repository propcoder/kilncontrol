#sudo systemctl stop mkitapp.service
#sudo systemctl stop mklauncher.service

sudo systemctl disable mkitapp.service
sudo systemctl disable mklauncher.service

sudo rm /etc/systemd/system/mkitapp.service
sudo rm /etc/systemd/system/mklauncher.service

systemctl --system daemon-reload

sudo systemctl status mkitapp.service
sudo systemctl status mklauncher.service

