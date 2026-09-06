# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'Calamares Bootloader Configuration' do

  it 'configures GRUB with Breeze theme, auto high-resolution gfxmode, and clean defaults' do
    grub_default = File.read('config/includes.chroot/etc/default/grub')
    expect(grub_default).not_to match(/GRUB_ENABLE_CRYPTODISK=y/)
    expect(grub_default).to match(/quiet splash/)
    expect(grub_default).to match(/GRUB_TERMINAL_OUTPUT="gfxterm"/)
    expect(grub_default).to match(/GRUB_GFXMODE="1920x1080,auto"/)
    expect(grub_default).to match(%r{GRUB_THEME="/boot/grub/themes/breeze/theme.txt"})

    installed_pkgs = File.read('config/package-lists/installed.list.chroot')
    expect(installed_pkgs).to match(/^grub-theme-breeze$/)
  end

  it 'configures Plymouth daemon with Spinner theme, 2x scaling, and package presence' do
    plymouth_conf = 'config/includes.chroot/etc/plymouth/plymouthd.conf'
    expect(File.exist?(plymouth_conf)).to be true
    content = File.read(plymouth_conf)
    expect(content).to match(/Theme=spinner/)
    expect(content).to match(/DeviceScale=2/)

    installed_pkgs = File.read('config/package-lists/installed.list.chroot')
    expect(installed_pkgs).to match(/^plymouth-themes$/)
  end
end
