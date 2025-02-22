#!/usr/bin/bash
steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2 | cut -d "." -f1,2)
rm -rf SDWEAK
sudo sed -i "s/main/3.5/g" /etc/pacman.conf &>/dev/null
sudo sed -i "s/3.6/3.5/g" /etc/pacman.conf &>/dev/null
sudo sed -i "s/3.7/3.5/g" /etc/pacman.conf &>/dev/null
sudo pacman -Sy --noconfirm git-lfs
if [ $steamos_version = 3.7 ]
then
    sudo sed -i "s/3.5/3.7/g" /etc/pacman.conf
fi
if [ $steamos_version = 3.6 ]
then
    sudo sed -i "s/3.5/3.6/g" /etc/pacman.conf
fi
if [ $steamos_version = 3.8 ]
then
    sudo sed -i "s/3.5/main/g" /etc/pacman.conf
fi
git clone https://github.com/Taskerer/SDWEAK.git
cd SDWEAK
sudo ./install.sh
