#!/usr/bin/fish
source (status dirname)/../lib/hobbylib.fish

set -l iso_version $argv[1]
if test -z "$iso_version"; and test -f VERSION
    set iso_version (string trim (cat VERSION))
end

if test -z "$iso_version"
    log_error "Version not specified and VERSION file not found!!"
    exit 1
end

set -l host_uid (id -u)
set -l host_gid (id -g)

mkdir -p build

log_info "Pulling down builder image (debian:bookworm)..."
docker pull debian:trixie

log_info "Building Hobby Linux v$iso_version ISO... 🙏📿"
docker run --rm --privileged -v (pwd):/repo -w /repo \
    -e DEBIAN_FRONTEND=noninteractive \
    debian:trixie bash -c \
    "apt-get update && apt-get install -y apt-utils live-build squashfs-tools grub-common grub-pc-bin grub-efi-amd64-bin mtools dosfstools xorriso && \
      if [ -f /usr/bin/mksquashfs ] && [ ! -f /usr/bin/mksquashfs.real ]; then \
        mv /usr/bin/mksquashfs /usr/bin/mksquashfs.real && \
        printf '#!/bin/sh\nexec /usr/bin/mksquashfs.real \"\$@\" -comp xz -b 1048576 -Xdict-size 100%%\n' > /usr/bin/mksquashfs && \
        chmod +x /usr/bin/mksquashfs; \
      fi && \
      mkdir -p /repo/build && \
      cd /repo/build && \
      ln -snf ../auto auto && \
      ln -snf ../config config && \
      lb config --image-name hobbylinux-$iso_version-amd64 && \
      lb build 2>&1 | tee build.log && \
      if [ -f live-image-amd64.hybrid.iso ]; then mv -f live-image-amd64.hybrid.iso hobbylinux-$iso_version-amd64.iso; fi && \
      if [ -f hobbylinux-$iso_version-amd64.hybrid.iso ]; then mv -f hobbylinux-$iso_version-amd64.hybrid.iso hobbylinux-$iso_version-amd64.iso; fi && \
      chown -R $host_uid:$host_gid /repo/build"
