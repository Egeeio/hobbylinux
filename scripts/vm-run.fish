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

mkdir -p vm
test -f vm/hobbylinux-test.qcow2; or qemu-img create -f qcow2 vm/hobbylinux-test.qcow2 20G
test -f vm/OVMF_VARS.fd; or cp /usr/share/OVMF/OVMF_VARS_4M.fd vm/OVMF_VARS.fd 2>/dev/null; or true

set -l qemu_cmd qemu-system-x86_64 \
    -enable-kvm \
    -m 4G \
    -smp 2 \
    -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd \
    -drive if=pflash,format=raw,file=vm/OVMF_VARS.fd \
    -drive file=vm/hobbylinux-test.qcow2,format=qcow2,if=virtio \
    -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 \
    -vga virtio \
    -display gtk,gl=on

if test -n "$iso"
    set -a qemu_cmd -cdrom "$iso" -boot d
end

$qemu_cmd
