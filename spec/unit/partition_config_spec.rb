# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'Calamares Partitioning Configuration' do
  let(:config_path) { 'config/includes.chroot/etc/calamares/modules/partition.conf' }

  it 'defaults to xfs with unencrypted boot and unchecked encryption default' do
    expect(File.exist?(config_path)).to be true

    data = YAML.safe_load_file(config_path)
    expect(data['defaultFileSystemType']).to eq('xfs')
    expect(data['defaultPartitionTableType']).to eq('gpt')
    expect(data['createHybridBootloaderLayout']).to be false
    expect(data['luksGeneration']).to eq('luks2')
    expect(data['preCheckEncryption']).to be false

    expect(data['efiSystemPartition']).to eq('/boot/efi')

    layout = data['partitionLayout'] || []
    boot_part = layout.find { |p| p['mountPoint'] == '/boot' }
    expect(boot_part).not_to be_nil
    expect(boot_part['filesystem']).to eq('ext4')

    root_part = layout.find { |p| p['mountPoint'] == '/' }
    expect(root_part).not_to be_nil
    expect(root_part['filesystem']).to eq('xfs')
  end
end
