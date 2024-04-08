require_relative 'helpers'

def bootstrap()
  stream_cmd("pacstrap -K /mnt base linux-lts btrfs-progs archlinux-keyring syslinux nano sudo fish neofetch")
  arch_chroot_runner("pacman-key --init && pacman-key --populate")
  arch_chroot_runner("syslinux-install_update -i -m -a")
  stream_cmd(sed('sda3', 'sda1', '/mnt/boot/syslinux/syslinux.cfg'))
  stream_cmd(sed('vmlinuz-linux', 'vmlinuz-linux-lts', '/mnt/boot/syslinux/syslinux.cfg'))
  stream_cmd(sed('initramfs-linux', 'initramfs-linux-lts', '/mnt/boot/syslinux/syslinux.cfg'))
  stream_cmd(sed('Arch Linux', 'Hobby Linux', '/mnt/boot/syslinux/syslinux.cfg'))
  stream_cmd(sed('Arch Linux', 'Hobby Linux', '/etc/os-release'))
  stream_cmd(sed('Arch Linux', 'Hobby Linux', '/usr/lib/os-release'))
  stream_cmd(sed('# Misc option', 'ILoveCandy', '/mnt/etc/pacman.conf'))
  stream_cmd('echo hobbylinux > /etc/hostname')
  stream_cmd("cp -rf /etc/systemd/network/* /mnt/etc/systemd/network/")
  arch_chroot_runner(activate_service("systemd-resolved systemd-networkd"))
end