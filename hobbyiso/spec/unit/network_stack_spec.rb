# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Network, Printing & Inter-Device Stack Configuration' do
  let(:nm_iwd_conf) { 'config/includes.chroot/etc/NetworkManager/conf.d/10-wifi-iwd.conf' }
  let(:nm_resolved_conf) { 'config/includes.chroot/etc/NetworkManager/conf.d/20-resolved.conf' }
  it 'configures NetworkManager with iwd Wi-Fi backend and systemd-resolved DNS' do
    expect(File.exist?(nm_iwd_conf)).to be true
    expect(File.read(nm_iwd_conf)).to match(/wifi\.backend=iwd/)

    expect(File.exist?(nm_resolved_conf)).to be true
    expect(File.read(nm_resolved_conf)).to match(/dns=systemd-resolved/)
  end
end
