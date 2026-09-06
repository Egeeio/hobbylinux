#!/usr/bin/fish
set -g fish_trace 1

source /usr/local/lib/hobbylib.fish

log_info "Settling udev hardware probing..."
udevadm settle --timeout=10

log_info "Verifying package manager locks..."
while fuser /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/lib/apt/lists/lock
    sleep 0.5
end

log_info "Launching Calamares installer..."
exec calamares-install-debian $argv
