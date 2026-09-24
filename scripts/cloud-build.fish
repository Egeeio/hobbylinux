#!/usr/bin/fish
source (status dirname)/../lib/hobbylib.fish

set -l cloud_version $argv[1]
if test -z "$cloud_version"; and test -f VERSION
    set cloud_version (string trim (cat VERSION))
end

if test -z "$cloud_version"
    log_error "Version not specified and VERSION file not found!"
    exit 1
end

set -l host_uid (id -u)
set -l host_gid (id -g)
set -l target_file "build/hobbylinux-$cloud_version-cloud-amd64.qcow2"
set -l base_cache "build/debian-13-genericcloud-amd64-base.qcow2"
set -l debian_cloud_url "https://cloud.debian.org/images/cloud/trixie/daily/latest/debian-13-genericcloud-amd64-daily.qcow2"

mkdir -p build

# 1. Download official Debian cloud base image if not cached
if not test -f "$base_cache"
    log_info "Downloading Debian Trixie official cloud base image..."
    curl -fL --progress-bar -o "$base_cache" "$debian_cloud_url"
    if not test -f "$base_cache"
        log_error "Failed to download Debian cloud base image!"
        exit 1
    end
else
    log_info "Using cached Debian cloud base: $base_cache"
end

# 2. Copy base image to target output
log_info "Preparing $target_file..."
cp -f "$base_cache" "$target_file"

# 3. Read package lists for headless server
set -l packages (grep -vh '^[[:space:]]*#' profiles/server.list | grep -v '^[[:space:]]*$' | tr '\n' ',' | sed 's/,$//')

log_info "Customizing Hobby Linux Cloud QCOW2 with virt-customize... ☁️🐧"

docker run --rm --device /dev/kvm -v (pwd):/repo -w /repo \
    -e DEBIAN_FRONTEND=noninteractive \
    debian:trixie bash -c "
      set -euo pipefail
      export LIBGUESTFS_BACKEND=direct

      apt-get update -qq
      apt-get install -y -qq guestfs-tools linux-image-amd64

      virt-customize -a /repo/$target_file \
        --no-selinux-relabel \
        --install \"$packages\" \
        --copy-in config/includes.chroot/usr/lib/os-release:/usr/lib/ \
        --copy-in config/includes.chroot/etc/cloud/cloud.cfg.d/99-hobby.cfg:/etc/cloud/cloud.cfg.d/ \
        --copy-in config/includes.chroot/etc/ssh/sshd_config.d/99-hobby-cloud.conf:/etc/ssh/sshd_config.d/ \
        --copy-in config/includes.chroot/etc/fish/conf.d/hobby-terminal.fish:/etc/fish/conf.d/ \
        --copy-in config/includes.chroot/etc/fish/conf.d/hobby-nala.fish:/etc/fish/conf.d/ \
        --copy-in config/includes.chroot/etc/systemd/zram-generator.conf:/etc/systemd/ \
        --copy-in config/includes.chroot/etc/sysctl.d/99-hobby-zram.conf:/etc/sysctl.d/ \
        --copy-in config/includes.chroot/etc/profile.d/hobby-nala.sh:/etc/profile.d/ \
        --copy-in config/includes.chroot/usr/local/lib/hobbylib.fish:/usr/local/lib/ \
        --copy-in config/includes.chroot/etc/systemd/journald.conf.d/10-persistent.conf:/etc/systemd/journald.conf.d/ \
        --copy-in config/includes.chroot/etc/apt/apt.conf.d/20auto-upgrades:/etc/apt/apt.conf.d/ \
        --copy-in config/includes.chroot/etc/apt/apt.conf.d/52hobby-auto-upgrades:/etc/apt/apt.conf.d/ \
        --run-command \"ln -sf ../usr/lib/os-release /etc/os-release\" \
        --run-command \"chsh -s /usr/bin/fish root\" \
        --run-command \"useradd -m -s /usr/bin/fish -G sudo hobby 2>/dev/null || true\" \
        --run-command \"mkdir -p /home/hobby/.ssh && chmod 700 /home/hobby/.ssh && chown -R hobby:hobby /home/hobby/.ssh\" \
        --run-command \"mkdir -p /var/lib/systemd/linger && touch /var/lib/systemd/linger/hobby\" \
        --run-command \"echo 'hobby ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/hobby && chmod 440 /etc/sudoers.d/hobby\" \
        --run-command \"echo 'hobbylinux' > /etc/hostname\" \
        --run-command \"ln -sf /usr/bin/sudo-rs /usr/local/bin/sudo && ln -sf /usr/bin/visudo-rs /usr/local/bin/visudo\" \
        --run-command \"sed -i 's/127.0.1.1.*/127.0.1.1 hobbylinux/' /etc/hosts 2>/dev/null || true\" \
        --run-command \"sed -i 's/Components: main.*/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources 2>/dev/null || true\" \
        --run-command \"apt-get clean && rm -rf /var/lib/apt/lists/*\"

      chown $host_uid:$host_gid /repo/$target_file
    "

if test -f "$target_file"
    set -l file_size (du -h "$target_file" | cut -f1)
    log_info "Successfully built $target_file ($file_size)"
else
    log_error "Cloud QCOW2 build failed!"
    exit 1
end
