# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'Calamares Locale & Timezone Configuration' do
  let(:config_path) { 'config/includes.chroot/etc/calamares/modules/locale.conf' }

  it 'configures GeoIP automatic timezone detection' do
    expect(File.exist?(config_path)).to be true

    data = YAML.safe_load_file(config_path)
    geoip = data['geoip'] || {}

    expect(geoip['style']).to eq('json')
    expect(geoip['url']).to eq('https://geoip.kde.org/v1/calamares')
    expect(geoip['selector']).to eq('time_zone')
  end
end
