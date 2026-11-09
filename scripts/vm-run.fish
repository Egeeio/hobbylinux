#!/usr/bin/fish
source (status dirname)/../lib/hobbylib.fish

set -l attach_iso 0
set -l iso ""

for arg in $argv
    if test "$arg" = "--iso"
        set attach_iso 1
    else if test -n "$arg"
        set iso "$arg"
        set attach_iso 1
    end
end

if test $attach_iso -eq 1
    if test -z "$iso"
        set -l build_dir (status dirname)/../build
        set -l latest_iso (ls -t $build_dir/*.iso 2>/dev/null | head -n 1)
        if test -n "$latest_iso"; and test -f "$latest_iso"
            set iso "$latest_iso"
            log_info "Auto-detected latest ISO: $iso"
        else
            log_error "No ISO specified and no *.iso files found in $build_dir"
            exit 1
        end
    else if not test -f "$iso"
        log_error "ISO file not found: $iso"
        exit 1
    end
    log_info "Booting VM with CD-ROM: $iso"
else
    log_info "Booting local VM disk directly (no ISO attached)"
end

set -q OVMF_CODE; or set -l OVMF_CODE "/usr/share/OVMF/OVMF_CODE_4M.fd"
set -q OVMF_VARS; or set -l OVMF_VARS "/usr/share/OVMF/OVMF_VARS_4M.fd"

mkdir -p vm
test -f vm/hobbylinux-test.qcow2; or qemu-img create -f qcow2 vm/hobbylinux-test.qcow2 20G
test -f vm/OVMF_VARS.fd; or cp $OVMF_VARS vm/OVMF_VARS.fd 2>/dev/null; or true

set -l qemu_cmd qemu-system-x86_64 \
    -enable-kvm \
    -m 4G \
    -smp 2 \
    -drive if=pflash,format=raw,readonly=on,file=$OVMF_CODE \
    -drive if=pflash,format=raw,file=vm/OVMF_VARS.fd \
    -drive file=vm/hobbylinux-test.qcow2,format=qcow2,if=virtio \
    -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 \
    -device virtio-vga-gl \
    -display sdl,gl=on

if test $attach_iso -eq 1
    set -a qemu_cmd -cdrom "$iso" -boot d
end

$qemu_cmd
