def desktop()
  puts `arch-chroot /mnt /bin/bash -c "pacman --noconfirm -S htop lightdm lightdm-gtk-greeter mate mate-extra"`
  puts `arch-chroot /mnt /bin/bash -c "systemctl enable lightdm"`
end