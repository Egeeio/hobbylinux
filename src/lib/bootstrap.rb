# frozen_string_literal: true

require_relative 'helpers'

def bootstrap
  stream_cmd('pacstrap -K /mnt base linux-lts xfsprogs archlinux-keyring syslinux nano sudo fish neofetch')
  stream_cmd('echo hobbylinux > /mnt/etc/hostname')
  stream_cmd('cp -rf /etc/systemd/network/* /mnt/etc/systemd/network/')
  arch_chroot_runner('hwclock --systohc')
  arch_chroot_runner('pacman-key --init && pacman-key --populate')
  arch_chroot_runner('syslinux-install_update -i -m -a')
  sed('sda3', 'sda1', '/mnt/boot/syslinux/syslinux.cfg')
  sed('vmlinuz-linux', 'vmlinuz-linux-lts', '/mnt/boot/syslinux/syslinux.cfg')
  sed('initramfs-linux', 'initramfs-linux-lts', '/mnt/boot/syslinux/syslinux.cfg')
  sed('Arch Linux', 'Hobby Linux', '/mnt/boot/syslinux/syslinux.cfg')
  sed('Arch Linux', 'Hobby Linux', '/mnt/etc/os-release')
  sed('Arch Linux', 'Hobby Linux', '/mnt/usr/lib/os-release')
  sed('# Misc options', 'ILoveCandy', '/mnt/etc/pacman.conf')
  activate_service('systemd-resolved systemd-networkd')
end
