#!/usr/bin/env bash
mkdir -p /run/user/0/dconf
dbus-launch --exit-with-session gsettings set org.mate.panel default-layout 'hobbylinux'
dbus-launch --exit-with-session gsettings set org.mate.interface document-font-name 'Montserrat Medium 10'
dbus-launch --exit-with-session gsettings set org.mate.interface font-name 'Montserrat Medium 10'
dbus-launch --exit-with-session gsettings set org.mate.interface gtk-theme 'Arc'
dbus-launch --exit-with-session gsettings set org.mate.interface icon-theme 'vintage'
dbus-launch --exit-with-session gsettings set org.mate.interface monospace-font-name 'Hack Bold 10'
dbus-launch --exit-with-session gsettings set org.mate.Marco.general titlebar-font 'Montserrat Medium 10'
dbus-launch --exit-with-session gsettings set org.mate.Marco.general theme 'Arc'
dbus-launch --exit-with-session gsettings set org.mate.Marco.general center-new-windows true
dbus-launch --exit-with-session gsettings set org.mate.caja.desktop font 'Montserrat Medium 10'
