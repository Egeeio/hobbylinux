# frozen_string_literal: true

# Upstream documentation:
# https://wiki.debian.org/UnattendedUpgrades

require 'spec_helper'

RSpec.describe 'APT Auto-Upgrades Configuration' do
  let(:config_path) { 'config/includes.chroot/etc/apt/apt.conf.d/20auto-upgrades' }

  it 'has auto updates and unattended upgrades enabled' do
    expect(File.exist?(config_path)).to be true

    content = File.read(config_path)

    expect(content).to match(/APT::Periodic::Update-Package-Lists\s+"1";/)
    expect(content).to match(/APT::Periodic::Download-Upgradeable-Packages\s+"1";/)
    expect(content).to match(/APT::Periodic::Unattended-Upgrade\s+"1";/)
    expect(content).to match(/APT::Periodic::AutocleanInterval\s+"7";/)
  end

  it 'configures unattended-upgrades origins to upgrade all Debian testing packages' do
    pattern_conf = 'config/includes.chroot/etc/apt/apt.conf.d/52hobby-auto-upgrades'
    expect(File.exist?(pattern_conf)).to be true

    content = File.read(pattern_conf)
    expect(content).to match(/origin=Debian,codename=\$\{distro_codename\}/)
    expect(content).to match(/Unattended-Upgrade::Remove-Unused-Dependencies\s+"true";/)
  end
end
