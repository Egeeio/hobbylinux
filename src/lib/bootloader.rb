# frozen_string_literal: true

require_relative 'helpers'

def bootloader
  pacman_install('grub efibootmgr os-prober')
  stream_cmd('grub-install /dev/sda') # TODO: Pass this in from installer.rb
  stream_cmd('grub-mkconfig -o /boot/grub/grub.cfg')
end
