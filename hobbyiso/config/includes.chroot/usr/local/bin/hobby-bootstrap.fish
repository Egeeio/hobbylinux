#!/usr/bin/fish

source /usr/local/lib/hobbylib.fish

# Never execute in live ISO session!
if test -d /run/live; or grep -q 'boot=live' /proc/cmdline
    log_error "This is a live session! Bailing out..."
    exit 1
end

set -g done_file "$HOME/.local/state/hobby-bootstrap.done"

if test -f "$done_file"
    log_warn "$done_file exists! Bailing out..."
    exit 0
end

function main
    set -l konqis /usr/share/plasma/avatars/*.png
    if test (count $konqis) -gt 0
        set -l chosen (random choice $konqis)
        log_info "Assigning Konqi avatar..."
        cp -f "$chosen" "$HOME/.face.icon" # These .face files might not be needed... idk
        cp -f "$chosen" "$HOME/.face"
        chmod 644 "$HOME/.face.icon" "$HOME/.face"
        if command -q busctl
            busctl call org.freedesktop.Accounts /org/freedesktop/Accounts/User(id -u) org.freedesktop.Accounts.User SetIconFile s "$chosen" &>/dev/null; or true
        else if command -q dbus-send
            dbus-send --system --dest=org.freedesktop.Accounts --type=method_call /org/freedesktop/Accounts/User(id -u) org.freedesktop.Accounts.User.SetIconFile string:"$chosen" &>/dev/null; or true
        end
    end


    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "≈    Welcome to Hobby Linux Bootstrap    ≈"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""

    log_info "Verifying internet connection..."
    while not ping -c 1 networkcheck.kde.org
        log_warn "Waiting for network connectivity..."
        sleep 2
    end

    echo ""
    echo "Select optional application bundles to install (multi-select e.g. 1,3):"
    echo "  1) Gaming (Steam, Heroic, RetroArch, Moonlight)"
    echo "  2) HTPC (Kodi, Jellyfin, MakeMKV, HandBrake)"
    echo "  3) Content Creation (OBS Studio, Kdenlive, Krita, Audacity, Blender, DigiKam)"
    echo "  4) Development (Docker, QEMU, Ruby, Build Tools, VSCodium)"
    echo "  5) Skip / Minimal Installation (default)"
    echo ""

    set -l choice
    read -P "Enter choice(s) [1-5] (default: 5): " choice
    set choice (string trim -- "$choice")
    test -z "$choice"; and set choice "5"

    set -l selections (string match -ra "[1-4]" "$choice")
    set -l flatpaks_to_install

    if contains 1 $selections
        log_info "Selected: Gaming package group"
        set -a flatpaks_to_install \
            com.valvesoftware.Steam \
            com.heroicgameslauncher.hgl \
            org.libretro.RetroArch \
            com.moonlight_stream.Moonlight
    end

    if contains 2 $selections
        log_info "Selected: HTPC package group"
        set -a flatpaks_to_install \
            tv.kodi.Kodi \
            com.github.iwalton3.jellyfin-media-player \
            fr.handbrake.ghb \
            com.makemkv.MakeMKV
    end

    if contains 3 $selections
        log_info "Selected: Content Creation package group"
        set -a flatpaks_to_install \
            com.obsproject.Studio \
            org.kde.kdenlive \
            org.kde.krita \
            org.audacityteam.Audacity \
            org.blender.Blender \
            org.kde.digikam
    end

    if contains 4 $selections
        log_info "Selected: Development package group"
        set -a flatpaks_to_install \
            com.vscodium.codium
    end

    if test (count $selections) -gt 0
        set -a flatpaks_to_install \
            com.vivaldi.Vivaldi \
            org.videolan.VLC \
            com.github.tchx84.Flatseal
    end

    if test (count $flatpaks_to_install) -gt 0
        log_info "Installing selected package groups..."
        flatpak --user install -y flathub $flatpaks_to_install
    else
        log_info "Skipping package group installation!"
    end

    if contains 4 $selections
        log_info "Installing Development package group (Docker, QEMU, Ruby, build tools) via Nala... (sudo required)"
        sudo nala update; and sudo nala install -y \
            build-essential \
            linux-headers-amd64 \
            git \
            cmake \
            pkg-config \
            ruby \
            rake \
            shellcheck \
            docker.io \
            qemu-system-x86 \
            ovmf
        sudo usermod -aG docker $USER
    end

    rm -f "$HOME/.config/autostart/hobby-bootstrap.desktop"
    touch "$done_file"

    echo ""
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "≈    Hobby Linux Bootstrap Complete!     ≈"
    echo "≈  Press Enter to close this terminal.   ≈"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    read -P "Press Enter to exit..." _any
end

main
