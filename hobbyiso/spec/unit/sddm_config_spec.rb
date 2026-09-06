# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'SDDM Wayland Greeter Configuration' do
  let(:sddm_wayland_conf_path) { 'config/includes.chroot/etc/sddm.conf.d/10-wayland.conf' }
  let(:desktop_pkgs_path) { 'config/package-lists/installed.list.chroot' }

  it 'provisions SDDM Wayland configuration with kwin_wayland compositor' do
    expect(File.exist?(sddm_wayland_conf_path)).to be true
    content = File.read(sddm_wayland_conf_path)
    expect(content).to match(/DisplayServer\s*=\s*wayland/)
    expect(content).to match(/CompositorCommand\s*=\s*kwin_wayland/)
    expect(content).to match(/--no-global-shortcuts/)
    expect(content).to match(/--no-lockscreen/)
    expect(content).to match(/--locale1/)
  end
end
