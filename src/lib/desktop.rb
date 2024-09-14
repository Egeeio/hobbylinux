# frozen_string_literal: true

require_relative 'helpers'

def desktop
  pacman_install('htop lightdm lightdm-gtk-greeter gtk-theme-elementary elementary-icon-theme cinnamon')
  activate_service('lightdm')
end
