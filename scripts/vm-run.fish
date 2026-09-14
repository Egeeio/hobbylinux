#!/usr/bin/fish
source (status dirname)/../lib/hobbylib.fish

set -l iso $argv[1]

if test -n "$iso"
    if not test -f "$iso"
        log_error "iso file not found: $iso"
        exit 1
    end
    log_info "booting vm cdrom: $iso"
else
    log_info "booting local vm disk"
end

hobby_qemu $iso
