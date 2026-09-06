# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Real-time Audio Scheduling Configuration' do
  let(:limits_path) { 'config/includes.chroot/etc/security/limits.d/25-pipewire.conf' }
  let(:hook_path) { 'config/hooks/live/0100-hobby-setup.hook.chroot' }
  let(:package_list_path) { 'config/package-lists/installed.list.chroot' }

  it 'provisions PAM limits granting real-time scheduling priority to audio group' do
    expect(File.exist?(limits_path)).to be true
    content = File.read(limits_path)
    expect(content).to match(/@audio\s+-\s+rtprio\s+95/)
    expect(content).to match(/@audio\s+-\s+nice\s+-19/)
    expect(content).to match(/@audio\s+-\s+memlock\s+unlimited/)
  end

  it 'purges rtkit daemon in chroot setup hook' do
    hook_content = File.read(hook_path)
    expect(hook_content).to match(/apt-get purge -y rtkit/)
  end
end
