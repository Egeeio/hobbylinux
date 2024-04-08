def bootstrap
  `pacstrap -K /mnt base linux-lts btrfs-progs`
  `arch-chroot /mnt /bin/bash -c "echo hobbylinux > /etc/hostname"`
  `arch-chroot /mnt /bin/bash -c "echo hobbylinux > /etc/hostname"`
  `arch-chroot /mnt /bin/bash -c "pacman-key --init && pacman-key --populate"`
  `arch-chroot /mnt /bin/bash -c "pacman --noconfirm -Sy archlinux-keyring && pacman --noconfirm -Syu"`
  `arch-chroot /mnt /bin/bash -c "pacman --noconfirm -Sy syslinux"`
  `arch-chroot /mnt /bin/bash -c "syslinux-install_update -i -m -a"`
  `arch-chroot /mnt /bin/bash -c "sed -i 's/sda3/sda1/' /boot/syslinux/syslinux.cfg"`
  `arch-chroot /mnt /bin/bash -c "pacman --noconfirm -Sy nano sudo fish"`
  `arch-chroot /mnt /bin/bash -c "sed -i 's/# Misc options/ILoveCandy/' /etc/pacman.conf"`
  `arch-chroot /mnt /bin/bash -c "sed -i 's/vmlinuz-linux/vmlinuz-linux-lts/' /boot/syslinux/syslinux.cfg"`
  `arch-chroot /mnt /bin/bash -c "sed -i 's/initramfs-linux/initramfs-linux-lts/' /boot/syslinux/syslinux.cfg"`
  `arch-chroot /mnt /bin/bash -c "sed -i 's/Arch Linux/Hobby Linux/' /boot/syslinux/syslinux.cfg"`
  `arch-chroot /mnt /bin/bash -c "sed -i 's/Arch Linux/Hobby Linux/' /etc/os-release"`
  `arch-chroot /mnt /bin/bash -c "sed -i 's/Arch Linux/Hobby Linux/' /usr/lib/os-release"`
  `cp /etc/systemd/network/* /mnt/etc/systemd/network/`
  `arch-chroot /mnt /bin/bash -c "systemctl enable systemd-resolved && systemctl enable systemd-networkd"`
end