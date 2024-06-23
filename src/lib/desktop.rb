# frozen_string_literal: true

require 'fileutils'
require_relative 'helpers'

def desktop(user)
  install_coreutils
  install_lightdm
  install_desktop
  # install_paru(user)
  configure_desktop(user)
end

def install_coreutils
  pacman_install('htop ruby git curl wget jq bc')
end

def install_lightdm
  pacman_install('lightdm lightdm-slick-greeter')
  sed('#greeter-session=example-gtk-gnome', 'greeter-session=lightdm-slick-greeter', '/mnt/etc/lightdm/lightdm.conf')
  activate_service('lightdm')
end

def install_desktop
  pacman_install('mate mate-extra otf-montserrat deepin-icon-theme arc-gtk-theme pipewire network-manager-applet')
end

def configure_desktop(user_name)
  # Folders
  ['.local/bin', 'Documents', 'Downloads', 'Music', 'Pictures', 'Projects', 'Public', 'Videos'].each do |folder|
    arch_chroot_runner("mkdir -p /home/#{user_name}/#{folder}", user_name)
  end

  # arch_chroot_runner("ln -s /home/#{user_name}/.local/bin /home/#{user_name}/Projects", user_name)

  FileUtils.cp('files/hobbylinux.layout', '/mnt/usr/share/mate-panel/layouts')
  FileUtils.cp('scripts/configure_desktop.sh', "/mnt/home/#{user_name}/configure_desktop.sh")
  arch_chroot_runner("/home/#{user_name}/configure_desktop.sh #{user_name}")
end
