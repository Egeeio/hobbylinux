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

    expect(content).to match(/apt-get clean/)
    expect(content).to match(%r{rm -rf /var/cache/apt/archives/\*\.deb})
    expect(content).to match(%r{rm -rf /var/lib/apt/lists/\*})
    expect(content).to match(%r{find /usr/share/doc -type f -not -name "copyright\*"})
    expect(content).to match(/apt-get autoremove -y --purge/)
  end

  it 'configures xz squashfs compression with 1M block size' do
    auto_config = File.read('auto/config')
    expect(auto_config).to match(/export MKSQUASHFS_OPTIONS=".*-comp xz/)
    expect(auto_config).to match(/-b 1048576/)

    if File.exist?('Taskfile.yml')
      taskfile = File.read('Taskfile.yml')
      expect(taskfile).to match(/MKSQUASHFS_OPTIONS="-comp xz/)
      expect(taskfile).to match(/squashfs-tools/)
    end

    if File.exist?('Rakefile')
      rakefile = File.read('Rakefile')
      expect(rakefile).to match(/MKSQUASHFS_OPTIONS="-comp xz/)
      expect(rakefile).to match(/squashfs-tools/)
    end
  end
end
