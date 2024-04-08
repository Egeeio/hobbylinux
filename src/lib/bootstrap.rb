def bootstrap()
  puts `pacstrap -K /mnt base linux-lts btrfs-progs`
  puts `arch-chroot /mnt /bin/bash -c "echo hobbylinux > /etc/hostname"`
  puts `arch-chroot /mnt /bin/bash -c "echo hobbylinux > /etc/hostname"`
  puts `arch-chroot /mnt /bin/bash -c "pacman-key --init && pacman-key --populate"`
  puts `arch-chroot /mnt /bin/bash -c "pacman --noconfirm -Sy archlinux-keyring && pacman --noconfirm -Syu"`
  puts `arch-chroot /mnt /bin/bash -c "pacman --noconfirm -Sy syslinux"`
  puts `arch-chroot /mnt /bin/bash -c "syslinux-install_update -i -m -a"`
  puts `arch-chroot /mnt /bin/bash -c "sed -i 's/sda3/sda1/' /boot/syslinux/syslinux.cfg"`
  puts `arch-chroot /mnt /bin/bash -c "pacman --noconfirm -Sy nano sudo fish"`
  puts `arch-chroot /mnt /bin/bash -c "sed -i 's/# Misc options/ILoveCandy/' /etc/pacman.conf"`
  puts `arch-chroot /mnt /bin/bash -c "sed -i 's/vmlinuz-linux/vmlinuz-linux-lts/' /boot/syslinux/syslinux.cfg"`
  puts `arch-chroot /mnt /bin/bash -c "sed -i 's/initramfs-linux/initramfs-linux-lts/' /boot/syslinux/syslinux.cfg"`
  puts `arch-chroot /mnt /bin/bash -c "sed -i 's/Arch Linux/Hobby Linux/' /boot/syslinux/syslinux.cfg"`
  puts `arch-chroot /mnt /bin/bash -c "sed -i 's/Arch Linux/Hobby Linux/' /etc/os-release"`
  puts `arch-chroot /mnt /bin/bash -c "sed -i 's/Arch Linux/Hobby Linux/' /usr/lib/os-release"`
  puts `cp /etc/systemd/network/* /mnt/etc/systemd/network/`
  puts `arch-chroot /mnt /bin/bash -c "systemctl enable systemd-resolved && systemctl enable systemd-networkd"`
end