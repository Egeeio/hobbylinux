#!/usr/bin/env bash
USER_NAME=ocean
USER_PASSWORD=ocean

fdisk /dev/sda
mkfs.ext4 /dev/sda1
mount /dev/sda /mnt
pacstrap -K /mnt base linux nano htop syslinux sudo wget git

su ${USER_NAME} -c "cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm"

syslinux_install-update -i -m -a
sed -i "s/sda3/sda1/" /etc/syslinux.conf
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i "s/# Misc options/ILoveCandy/" /etc/pacman.conf

echo -e "${USER_PASSWORD}\n${USER_PASSWORD}" | passwd root
echo -e "${USER_PASSWORD}\n${USER_PASSWORD}" | passwd ${USER_NAME}
echo "${USER_NAME}   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
usermod -aG adm ${USER_NAME}

cp /etc/systemd/network/20-ethernet.network
nano /boot/syslinux/syslinux.cfg

systemctl enable systemd-resolved
systemctl enable systemd-networkd

#cinnamon
#sddm
