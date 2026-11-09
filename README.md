# Hobby Linux

**Hobby Linux** is a Linux distribution built atop Debian Testing (Trixie) with backports enabled. It sports a lightweight lxqt desktop on wayland via labwc, modern system plumbing, and defaults for tinkerers.

---

## Installation & Workflow

Hobby uses [`task`](https://taskfile.dev/) as the entry point to build a bootable iso inside an isolated docker container and spin up a local virtual machine with qemu

### Prerequisites

```sh
# Install Task:
mkdir -p ~/.local/bin
curl -sSL https://github.com/go-task/task/releases/latest/download/task_linux_amd64.tar.gz | tar -xz -C ~/.local/bin task

# Install Docker:
sudo apt install -y docker.io
```

---

### Pre-Install

1. **_Build_ the ISO:**
   ```sh
   task iso:build
   ```
   Uses a docker container running debian trixie with `live-build`, downloads packages, applies customizations, and writes a bootable image to `build/hobbylinux-*.iso`. ~8 minutes to run

2. **_Run_ the live ISO:**

   Use an [image writer](https://flathub.org/en/apps/search?q=iso) to burn the iso onto a usb and install it on hardware. Or test it with qemu:

   ```sh
   # Install qemu:
   sudo apt install -y qemu-system-x86 ovmf

   # Launch vm with iso
   task vm:iso
   ```

---

### Install

Desktop environment is [lxqt](https://lxqt-project.org). To begin, launch the **Install Hobby Linux** shortcut. A network connection is required! The installer is [calamares](https://calamares.io) and uses some helper scripts. Follow the install (partition, users, etc.) prompts and reboot when complete.

---

### Boot

1. **Boot into the Installed System:**
   ```sh
   task vm:run
   ```

2. **Use It**
  - Log in with your installed user
  - Enjoy your new os

---

### What Makes Hobby Kinda Interesting

* **Desktop Environment:** lxqt w/labwc wayland compositor
* **Default Shell:** `fish` login and interactive shell out of the box
* **Package Management:** `nala` package manager frontend
* **Automated Maintenance:** Weekly background online auto-upgrades & cleanups via `unattended-upgrades`
* **Internal Tunings:**
  * **sudo:** `sudo-rs` symlinked as default
  * **Networking:** `NetworkManager` w/`iwd` & `systemd-resolved`
  * **Audio:** `pipewire` with WirePlumber
  * **Memory:** `systemd-zram-generator` w/zstd
  * **Drivers:** Pre-installed microcodes, non-free firmwares, and filesystem utilities

---

### Artwork & License

* **Code & Configuration:** Licensed under the [MIT License](LICENSE)
* **Artwork & Branding:** All original artwork, wallpapers, and branding assets belong to **Egee** (All rights reserved)
