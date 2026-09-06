# Hobby Linux

**Hobby Linux** is a desktop Linux distribution built atop debian trixie (testing/rolling-ish) with kde plasma and some goodies. It includes some experimental defaults and a first-boot script that installs optional package groups.

It’s called Hobby Linux because it lets you explore the machinations of debian’s `live-build` ecosystem and calamares installer with your own personal hobby operating system.

---

## Installation & Workflow

Hobby uses `rake` as the entry point to build a bootable iso inside an isolated docker container and spin up a local virtual machine with qemu. **The steps below assume the default** qemu test environment but you can get the iso from `build/live-image-amd64.hybrid.iso` and copy it to an install medium also.

### Prerequisites

```sh
# On Debian/Ubuntu:
sudo apt install -y docker.io qemu-system-x86 ovmf rake
```

---

### Pre-Install

1. **_Build_ the iso:**
   ```sh
   rake iso:build
   ```
   Spins up a docker container, gets a debian with `live-build`, downloads packages, applies customizations, and writes a bootable image to `build/hobbylinux-*.iso`. takes about ~8 minutes to run.

2. **_Boot_ the live iso:**
   ```sh
   rake vm:boot
   ```
   Launches a qemu in uefi mode with kvm acceleration. creates a virtual disk (`vm/hobbylinux-test.qcow2`) and boots a live kde plasma desktop.

---

### Install / Live Desktop

![Hobby Linux Live Installation](.github/assets/hobby-install.webp)

The live desktop is a just a traditional kde plasma desktop. It's tuned for speed and compatiblity so works great as recovery live session.

To begin the install, launch the **Install Hobby Linux** shortcut. A network connection is required! The installer is driven by `calamares` alongside some fish helper scripts. Follow the install (partition, users, etc.) prompts and reboot when complete.

---

### Post-Install

![Hobby Linux Post-Installation](.github/assets/post-install.webp)

1. **Boot into the Installed System:**
   ```sh
   rake vm:run
   ```
   *(Or remove the installation USB if installing to bare-metal hardware).*

2. **Hobby Linux Bootstrap:**

   An automated setup script opens after login and lets you pick from list of package group along with the kde plasma welcome app. The bootstrap script will let you pre-install groups of packages and flatpaks and runs only at the very first boot.
   
   You can skip either or both.

---

### Core Defaults

Take a look at the tests under `specs/`. They are unit tests which also help document the code so its easier to get a better picture of what's inside at a glance. Summary:

* **Desktop Environment:** wayland-only kde plasma with dynamic breeze styling. desktop effects (animations, blur, transparencies) are disabled ootb
* **Firmware & Bootloader:** uefi with graphical grub, breeze theme, and plymouth spinner-splash screen with oem vendor logo support
* **Filesystem:** XFS w/optional encryption
* **System Configuration:** 
   * **sudo:** `sudo-rs`
   * **NetworkManager** `iwd` w/`systemd-resolved`
   * **AudioServer** `pipewire`
   * **Drivers** `this that` and microcodes
* **Software Management:** 
  * **System Level:** `nala`
  * **Application Level:** `flatpak --user` w/flathub
  * **Automated Rolling Maintenance:** `unattended-upgrades` with auto-upgrading packages (not just updating!)

---

### Known Issues

Some known issues I didn't or haven't had time to tackle just yet:

* Pinned apps in the default panel are wrong
* Home folders missing from the desktop
* VSCodium flatpak is a bit janky, needs better defaults
* SDDM doesn't use user's pfp
* Should start with fresh empty plasma session
* Iso build ought to use podman instead of docker

---

### Artwork & License

* **Code & Configuration:** Licensed under the [MIT License](LICENSE).
* **Artwork & Branding:** All original artwork, wallpapers, and branding assets belong to **Egee** (All rights reserved).
