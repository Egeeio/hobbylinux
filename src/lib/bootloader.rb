# frozen_string_literal: true

require_relative 'helpers'

def bootloader
  pacman_install('grub efibootmgr os-prober')
  arch_chroot_runner('grub-install /dev/sda') # TODO: Pass this in from installer.rb
  arch_chroot_runner('grub-mkconfig -o /boot/grub/grub.cfg')
end
