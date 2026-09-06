#!/usr/bin/fish
set -g fish_trace 1

source /usr/local/lib/hobbylib.fish

log_info "Cleaning up live environment files..."

log_debug "Deploying installed PowerDevil power management configuration..."
if test -f /etc/xdg/powerdevilrc.installed
    mv -f /etc/xdg/powerdevilrc.installed /etc/xdg/powerdevilrc
end

log_debug "Removing installer desktop shortcuts and live session permissions..."
rm -f /usr/share/applications/calamares-debian-installer.desktop
rm -f /usr/share/applications/calamares-install-debian.desktop
rm -f /usr/share/applications/install-debian.desktop
rm -f /etc/sudoers.d/hobby
rm -f /etc/polkit-1/rules.d/49-nopasswd_global.rules
rm -f /etc/sddm.conf.d/autologin.conf

log_debug "Regenerating unique SSH host keys for installed system..."
rm -f /etc/ssh/ssh_host_*_key*
ssh-keygen -A

log_debug "Cleaning up APT source repositories for installed system..."
if test -f /etc/apt/sources.list.d/debian.sources
    sed -i 's/deb-src//g' /etc/apt/sources.list.d/debian.sources
end
echo "# Repositories migrated to /etc/apt/sources.list.d/debian.sources" > /etc/apt/sources.list

log_debug "Migrating live Wi-Fi connections to system-wide autoconnect..."
for file in /etc/NetworkManager/system-connections/*.nmconnection
    if test -f "$file"
        log_info "Enabling system-wide autoconnect for $file..."
        sed -i '/^permissions=/d' "$file"
        if not grep -q '^autoconnect=' "$file"
            sed -i '/^\[connection\]/a autoconnect=true' "$file"
        end
        chmod 600 "$file"
    end
end

if test -d /tmp/iwd-live
    log_debug "Migrating live iwd network profiles to installed system..."
    mkdir -p /var/lib/iwd
    cp -af /tmp/iwd-live/*.psk /var/lib/iwd/ 2>/dev/null || true
    chmod 700 /var/lib/iwd
    chmod 600 /var/lib/iwd/*.psk 2>/dev/null || true
end

log_debug "Unmasking background system services on installed target..."
hobby_unmask_live_services

log_debug "Removing installer helper scripts from /usr/local/bin..."
rm -f /usr/local/bin/hobby-bootloader-install.fish
rm -f /usr/local/bin/hobby-calamares-launcher.fish
rm -f /usr/local/bin/hobby-cleanup.fish

log_info "Cleanup complete."
