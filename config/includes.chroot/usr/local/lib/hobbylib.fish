# lib/hobbylib.fish
# Shared helper library for Hobby Linux

# Logging helper that outputs timestamped, color-coded messages based on level.
function hobby_log -a level
    set -l msg $argv[2..-1]
    set -l timestamp (date "+%Y-%m-%d %H:%M:%S")

    switch $level
        case DEBUG
            set_color blue
            echo "[$timestamp] [DEBUG] $msg" >&2
            set_color normal
        case INFO
            set_color green
            echo "[$timestamp] [INFO]  $msg"
            set_color normal
        case WARN
            set_color yellow
            echo "[$timestamp] [WARN]  $msg" >&2
            set_color normal
        case ERROR
            set_color red
            echo "[$timestamp] [ERROR] $msg" >&2
            set_color normal
        case '*'
            echo "[$timestamp] [$level] $msg"
    end
end

# Logs an informational message in green to stdout.
function log_info
    hobby_log INFO $argv
end

# Logs a warning message in yellow to stderr.
function log_warn
    hobby_log WARN $argv
end

# Logs an error message in red to stderr.
function log_error
    hobby_log ERROR $argv
end

# Logs a debug message in blue to stderr.
function log_debug
    hobby_log DEBUG $argv
end

# Launches a QEMU virtual machine in UEFI mode.
# Accepts optional ISO path as $argv[1] to mount as CD-ROM.
# Example: task vm:run ISO=build/hobbylinux-0.7.2-amd64-amd64.hybrid.iso
function hobby_qemu -a iso
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
end

# Runs a command inside the debian:testing build container
function hobby_docker_run
    docker run --rm --privileged -v (pwd):/repo -w /repo \
        -e DEBIAN_FRONTEND=noninteractive \
        -e MKSQUASHFS_OPTIONS="-comp xz -b 1048576 -Xdict-size 100%" \
        debian:testing bash -c "$argv"
end
