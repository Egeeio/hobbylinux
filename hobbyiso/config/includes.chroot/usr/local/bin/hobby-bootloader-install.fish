#!/usr/bin/fish
set -g fish_trace 1

source /usr/local/lib/hobbylib.fish

function install_uefi
    log_info "UEFI mode detected. Installing GRUB for x86_64-efi..."
    mkdir -p /boot/efi /boot/efi/EFI/BOOT
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=debian --recheck

    if test -f /boot/efi/EFI/debian/grubx64.efi
        cp /boot/efi/EFI/debian/grubx64.efi /boot/efi/EFI/BOOT/BOOTX64.EFI
        log_info "Copied fallback bootloader to /boot/efi/EFI/BOOT/BOOTX64.EFI"
    end
end

function main
    log_info "Starting Hobby Linux Bootloader Installation..."

    if not test -d /sys/firmware/efi
        log_error "UEFI firmware not detected. Hobby Linux requires UEFI!"
        exit 1
    end

    install_uefi

    if command -q update-initramfs
        log_info "Updating initramfs on target system..."
        update-initramfs -u -k all
    end

    if test -d /usr/share/grub/themes/breeze
        log_info "Deploying Breeze GRUB theme to /boot..."
        mkdir -p /boot/grub/themes
        cp -rf /usr/share/grub/themes/breeze /boot/grub/themes/
    end

    if command -q update-grub
        log_info "Updating GRUB configuration..."
        update-grub
    else
        log_warn "update-grub not found; running grub-mkconfig directly"
        grub-mkconfig -o /boot/grub/grub.cfg
    end

    log_info "Bootloader installation complete!"
end

main
