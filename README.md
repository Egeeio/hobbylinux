# Hobby Linux

**Hobby Linux** is a Linux distribution built atop Debian Testing (Trixie) with backports enabled. It sports a lightweight lxqt desktop with openbox, modern system plumbing, and defaults for tinkerers.

It’s called Hobby Linux because it lets you explore the machinations of Debian’s `live-build` ecosystem and Calamares installer with your own personal hobby operating system.

---

### What Makes Hobby Kinda Interesting

* **Default Shell:** `fish` is the default login and interactive shell out of the box.
* **Package Management:** `nala` is the default package manager frontend, with `apt` and `apt-get` aliased to `nala`.
* **Automated Maintenance:** Weekly background online auto-upgrades via tuned `unattended-upgrades` tracking Debian Testing with automatic dependency cleanup.
* **Internal Tunings:**
  * **sudo:** `sudo-rs` symlinked as default
  * **Networking:** `NetworkManager` w/`iwd` & `systemd-resolved`
  * **Audio:** `pipewire` with WirePlumber
  * **Memory:** `systemd-zram-generator` w/zstd
  * **Drivers:** Microcodes, non-free firmwares, and modern filesystem utilities pre-installed
* **Desktop & Boot:** Lightweight lxqt desktop with Openbox, UEFI boot with graphical GRUB and Plymouth spinner-splash, and a streamlined Calamares installer.

---

## Installation & Workflow

Hobby uses [`task`](https://taskfile.dev/) as the entry point to build a bootable ISO inside an isolated Docker container and spin up a local virtual machine with QEMU.

### Prerequisites

```sh
# Go Get Task (go-task):
mkdir -p ~/.local/bin
curl -sSL https://github.com/go-task/task/releases/latest/download/task_linux_amd64.tar.gz | tar -xz -C ~/.local/bin task

# Install Docker & Friends:
sudo apt install -y docker.io qemu-system-x86 ovmf
```

---

### Pre-Install

1. **_Build_ the ISO:**
   ```sh
   task iso:build
   ```
   Spins up a Docker container running Debian Trixie with `live-build`, downloads packages, applies customizations, and writes a bootable image to `build/hobbylinux-*.iso`. Takes about ~8 minutes to run.

2. **_Run_ the live ISO in QEMU:**
   ```sh
   task vm:run
   ```
   Launches QEMU in UEFI mode with KVM acceleration. Auto-provisions a virtual test disk (`vm/hobbylinux-test.qcow2`), UEFI NVRAM, and boots the newly built ISO.

---

### Install / Live Desktop

The live desktop is lxqt. To begin the install, launch the **Install Hobby Linux** shortcut. A network connection is required! The installer is `calamares` and uses some fish helper scripts. Follow the install (partition, users, etc.) prompts and reboot when complete.

---

### Post-Install

1. **Boot into the Installed System:**
   ```sh
   task vm:run
   ```
   *(Or remove the installation USB if installing to bare-metal hardware).*

---

### Artwork & License

* **Code & Configuration:** Licensed under the [MIT License](LICENSE).
* **Artwork & Branding:** All original artwork, wallpapers, and branding assets belong to **Egee** (All rights reserved).
