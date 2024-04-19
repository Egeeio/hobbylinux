# frozen_string_literal: true

require_relative 'helpers'

def desktop
  pacman_install('htop lightdm lightdm-gtk-greeter mate mate-extra')
  activate_service('lightdm')
end