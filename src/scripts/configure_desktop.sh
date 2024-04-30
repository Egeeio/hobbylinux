#!/usr/bin/env bash
USER_NAME="${1:hobby}"

mkdir -p /run/user/0/dconf
chown -R "$USER_NAME:$USER_NAME" /run/user/0

/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.panel default-layout 'hobbylinux'
/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.interface document-font-name 'Montserrat Medium 10'
/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.interface font-name 'Montserrat Medium 10'
/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.interface gtk-theme 'Arc'
/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.interface icon-theme 'vintage'
/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.interface monospace-font-name 'Hack Bold 10'
/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.Marco.general titlebar-font 'Montserrat Medium 10'
/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.Marco.general theme 'Arc'
/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.Marco.general center-new-windows true
/usr/bin/su -p "$USER_NAME" -c dbus-launch --exit-with-session gsettings set org.mate.caja.desktop font 'Montserrat Medium 10'
