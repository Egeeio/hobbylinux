# frozen_string_literal: true

require 'fileutils'
require_relative 'helpers'

def desktop(user)
  pacman_install('htop lightdm lightdm-slick-greeter mate mate-extra otf-montserrat deepin-icon-theme arc-gtk-theme pipewire')
  activate_service('lightdm')
  # Desktop
  arch_chroot_runner("gsettings set org.mate.desktop.interface document-font-name 'Montserrat Medium 10'")
  arch_chroot_runner("gsettings set org.mate.desktop.interface font-name 'Montserrat Medium 10'")
  arch_chroot_runner("gsettings set org.mate.desktop.interface gtk-theme 'Arc'")
  arch_chroot_runner("gsettings set org.mate.desktop.interface icon-name 'vintage'")
  arch_chroot_runner("gsettings set org.mate.desktop.interface monospace-font-name 'Hack Bold 10'")
  # Marco
  arch_chroot_runner("gsettings set org.mate.marco.general document-font-name 'Montserrat Medium 10'")
  arch_chroot_runner("gsettings set org.mate.marco.general theme 'Arc'")
  # Caja
  arch_chroot_runner("gsettings set org.mate.caja.desktop font 'Montserrat Medium 10'")
  ['.local/bin', 'Documents', 'Downloads', 'Music', 'Pictures', 'Projects', 'Public', 'Videos'].each do |folder|
    stream_cmd("mkdir -p /home/#{user}/#{folder}")
  end
  stream_cmd("ln -s /home/#{user}/.local/bin /home/#{user}/Projects/bin")

  # Panel
  FileUtils.mv('files/hobbylinux.layout', '/mnt/usr/share/mate-panel/layouts')
  arch_chroot_runner("gsettings set org.mate.panel.general default-layout 'hobbylinux'")
end
