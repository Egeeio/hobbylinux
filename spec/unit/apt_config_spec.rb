# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'APT Package Pinning & Preferences' do
  let(:pref_path) { 'config/includes.chroot/etc/apt/preferences.d/99-hobby-blocked-packages' }

  it 'pins superseded packages to priority -1 to prevent recommended installations' do
    expect(File.exist?(pref_path)).to be true
    content = File.read(pref_path)

    expect(content).to match(/Package:\s*rsyslog\nPin:\s*release\s*\*\nPin-Priority:\s*-1/)
    expect(content).to match(/Package:\s*rtkit\nPin:\s*release\s*\*\nPin-Priority:\s*-1/)
  end

  it 'cleans APT cache, package lists, and documentation in chroot setup hook' do
    hook_path = 'config/hooks/live/0100-hobby-setup.hook.chroot'
    expect(File.exist?(hook_path)).to be true
    content = File.read(hook_path)

    expect(content).to match(/clean/)
    expect(content).to match(%r{rm -rf /var/cache/apt/archives/\*\.deb})
    expect(content).to match(%r{rm -rf /var/lib/apt/lists/\*})
    expect(content).to match(/autoremove -y --purge/)
  end

  it 'provisions nala in chroot setup hook' do
    hook_path = 'config/hooks/live/0100-hobby-setup.hook.chroot'
    expect(File.exist?(hook_path)).to be true

    fish_alias = 'config/includes.chroot/etc/fish/conf.d/hobby-nala.fish'
    expect(File.exist?(fish_alias)).to be true
    expect(File.read(fish_alias)).to match(/alias apt="nala"/)
  end
end
