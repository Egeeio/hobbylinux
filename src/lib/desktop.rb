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
  pacman_install('mate mate-extra otf-montserrat deepin-icon-theme arc-gtk-theme pipewire network-manager-applet')
end

def configure_desktop(user_name)
  # Folders
  ['.local/bin', 'Documents', 'Downloads', 'Music', 'Pictures', 'Projects', 'Public', 'Videos'].each do |folder|
    arch_chroot_runner("mkdir -p /home/#{user_name}/#{folder}", user_name)
  end
  arch_chroot_runner("ln -s /home/#{user_name}/.local/bin /home/#{user_name}/Projects", user_name)
  # Panel
  FileUtils.cp('files/hobbylinux.layout', '/mnt/usr/share/mate-panel/layouts')
  arch_chroot_runner("dbus-launch --exit-with-session gsettings set org.mate.panel default-layout 'hobbylinux'", user_name)
  # Interface
  arch_chroot_runner("dbus-launch --exit-with-session gsettings set org.mate.interface document-font-name 'Montserrat Medium 10'", user_name)
  arch_chroot_runner("dbus-launch --exit-with-session gsettings set org.mate.interface font-name 'Montserrat Medium 10'", user_name)
  arch_chroot_runner("dbus-launch --exit-with-session gsettings set org.mate.interface gtk-theme 'Arc'", user_name)
  arch_chroot_runner("dbus-launch --exit-with-session gsettings set org.mate.interface icon-theme 'vintage'", user_name)
  arch_chroot_runner("dbus-launch --exit-with-session gsettings set org.mate.interface monospace-font-name 'Hack Bold 10'", user_name)
  # Marco
  arch_chroot_runner("dbus-launch --exit-with-session gsettings set org.mate.Marco.general titlebar-font 'Montserrat Medium 10'", user_name)
  arch_chroot_runner("dbus-launch --exit-with-session gsettings set org.mate.Marco.general theme 'Arc'", user_name)
  arch_chroot_runner('dbus-launch --exit-with-session gsettings set org.mate.Marco.general center-new-windows true', user_name)
  # Caja
  arch_chroot_runner("dbus-launch --exit-with-session gsettings set org.mate.caja.desktop font 'Montserrat Medium 10'", user_name)
end
