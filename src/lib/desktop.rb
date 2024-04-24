# frozen_string_literal: true

require 'fileutils'
require_relative 'helpers'

def desktop(user)
  install_coreutils
  install_lightdm
  install_desktop
  configure_desktop(user)
end

def install_coreutils
  pacman_install('htop ruby git curl wget')
end

def install_lightdm
  pacman_install('lightdm lightdm-slick-greeter')
  sed('#greeter-session=example-gtk-gnome', 'greeter-session=lightdm-slick-greeter', '/mnt/etc/lightdm/lightdm.conf')
  activate_service('lightdm')
end

def install_desktop
  pacman_install('mate mate-extra otf-montserrat deepin-icon-theme arc-gtk-theme pipewire')
end

def configure_desktop(user)
  # Folders
  ['.local/bin', 'Documents', 'Downloads', 'Music', 'Pictures', 'Projects', 'Public', 'Videos'].each do |folder|
    stream_cmd("mkdir -p /mnt/home/#{user}/#{folder}")
  end
  arch_chroot_runner("ln -s /home/#{user}/.local/bin /home/#{user}/Projects/bin")
  # Panel
  FileUtils.mv('files/hobbylinux.layout', '/mnt/usr/share/mate-panel/layouts')
  arch_chroot_runner("gsettings set org.mate.panel.general default-layout 'hobbylinux'")
  # Interface
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
end
