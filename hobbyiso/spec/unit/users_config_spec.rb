# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'Calamares Users Configuration' do
  let(:config_path) { 'config/includes.chroot/etc/calamares/modules/users.conf' }

  it 'includes required system admin, logging, and printer groups' do
    expect(File.exist?(config_path)).to be true

    data = YAML.safe_load_file(config_path)
    groups = data['defaultGroups'] || []

    expect(groups).to include('adm')
    expect(groups).to include('systemd-journal')
    expect(groups).to include('lpadmin')
    expect(groups).to include('netdev')

    expect(data['doAutologin']).to be false
  end
end
