# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'Calamares Packages Configuration' do

  it 'provisions fwupd.conf with uefi-dbx and msr plugins disabled' do
    fwupd_conf = 'config/includes.chroot/etc/fwupd/fwupd.conf'
    expect(File.exist?(fwupd_conf)).to be true
    content = File.read(fwupd_conf)
    expect(content).to match(/DisabledPlugins=.*uefi-dbx/)
    expect(content).to match(/DisabledPlugins=.*msr/)
  end
end


