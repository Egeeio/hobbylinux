# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'Post-Install Bootstrap Setup' do
  let(:skel_autostart_path) { 'config/includes.chroot/etc/skel/.config/autostart/hobby-bootstrap.desktop' }
  let(:xdg_autostart_path) { 'config/includes.chroot/etc/xdg/autostart/hobby-bootstrap.desktop' }
  let(:bootstrap_script_path) { 'config/includes.chroot/usr/local/bin/hobby-bootstrap.fish' }

  it 'provisions bootstrap autostart desktop entry in user skeleton (~/.config/autostart), not system-wide /etc/xdg' do
    expect(File.exist?(xdg_autostart_path)).to be false
    expect(File.exist?(skel_autostart_path)).to be true
    content = File.read(skel_autostart_path)
    expect(content).to match(%r{\.local/state/hobby-bootstrap\.done})
    expect(content).to match(%r{hobby-bootstrap\.fish})
    expect(content).to match(/Name=Hobby Linux Bootstrap/)
  end

  it 'provides executable bootstrap fish wizard with network check and state sentinel' do
    expect(File.exist?(bootstrap_script_path)).to be true
    expect(File.executable?(bootstrap_script_path)).to be true
    content = File.read(bootstrap_script_path)
    expect(content).to match(%r{\.local/state/hobby-bootstrap\.done})
    expect(content).to match(/networkcheck\.kde\.org/)
  end

  it 'pre-seeds Flathub remote for user skeleton in chroot setup hook' do
    hook_content = File.read('config/hooks/live/0100-hobby-setup.hook.chroot')
    expect(hook_content).to match(%r{flatpak --user remote-add.*flathub})
    expect(hook_content).to match(%r{/etc/skel/\.local/share/flatpak})
  end
end

