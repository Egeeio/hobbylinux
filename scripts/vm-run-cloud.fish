#!/usr/bin/fish
source (status dirname)/../lib/hobbylib.fish

set -l image $argv[1]

if test -z "$image"
    # Find latest cloud qcow2 in build/
    set -l images (ls -t build/*cloud-amd64.qcow2 2>/dev/null)
    if test (count $images) -gt 0
        set image $images[1]
    end
end

if test -z "$image"; or not test -f "$image"
    log_error "Cloud QCOW2 image not found! Build it first with 'task build:qcow' or specify IMAGE=path/to.qcow2"
    exit 1
end

log_info "Found cloud image: $image"

mkdir -p vm/cidata

# 1. Generate local test key if needed
if not test -f vm/id_ed25519_test
    log_info "Generating temporary local test SSH key: vm/id_ed25519_test"
    ssh-keygen -t ed25519 -f vm/id_ed25519_test -N "" -q
end

set -l pubkey (cat vm/id_ed25519_test.pub)

# 2. Generate cloud-init NoCloud seed files
printf '#cloud-config\nusers:\n  - name: hobby\n    ssh_authorized_keys:\n      - %s\nssh_pwauth: false\n' "$pubkey" > vm/cidata/user-data

printf 'instance-id: hobby-local-test\nlocal-hostname: hobbylinux-cloud\n' > vm/cidata/meta-data

# 3. Create ISO seed disk with volume ID 'cidata'
if command -q xorriso
    xorriso -as mkisofs -quiet -R -V cidata -o vm/seed.iso vm/cidata 2>/dev/null
else
    log_warn "xorriso not found; booting without local NoCloud seed disk"
end

# 4. Create disposable copy-on-write overlay so original image is untouched
set -l overlay "vm/hobbylinux-cloud-test.qcow2"
rm -f $overlay
qemu-img create -f qcow2 -b ../$image -F qcow2 $overlay >/dev/null

log_info ""~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~""
log_info "Starting Hobby Linux Cloud VM in QEMU..."
log_info "SSH forwarded to: localhost:2222"
log_info "Connect in another terminal via:"
log_info "  ssh -i vm/id_ed25519_test -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null hobby@localhost"
log_info "Press Ctrl+A then X to exit QEMU."
log_info ""~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~""

set -l qemu_cmd qemu-system-x86_64 \
    -enable-kvm \
    -m 2G \
    -smp 2 \
    -drive file=$overlay,format=qcow2,if=virtio \
    -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 \
    -nographic

if test -f vm/seed.iso
    set -a qemu_cmd -drive file=vm/seed.iso,format=raw,media=cdrom
end

$qemu_cmd
