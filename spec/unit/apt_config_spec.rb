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
end
