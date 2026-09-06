# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Desktop Addons & Wallpaper Configuration' do
  let(:desktop_list) { 'config/package-lists/installed.list.chroot' }

  it 'includes plasma-wallpapers-addons for Picture of the Day support' do
    pkgs = File.read(desktop_list)
    expect(pkgs).to match(/^plasma-wallpapers-addons$/)
  end

  it 'provisions Next wallpaper package with light and dark themes and SDDM override' do
    expect(File.exist?('config/includes.chroot/usr/share/wallpapers/Next/metadata.json')).to be true
    expect(File.exist?('config/includes.chroot/usr/share/wallpapers/Next/contents/images/background-light.webp')).to be true
    expect(File.exist?('config/includes.chroot/usr/share/wallpapers/Next/contents/images/5120x2880.png')).to be true
    expect(File.exist?('config/includes.chroot/usr/share/wallpapers/Next/contents/images_dark/background-dark.webp')).to be true
    expect(File.exist?('config/includes.chroot/usr/share/wallpapers/Next/contents/images_dark/5120x2880.png')).to be true
  end

  it 'provisions opaque panel defaults in plasmashellrc' do
    xdg_plasmashellrc = File.read('config/includes.chroot/etc/xdg/plasmashellrc')
    skel_plasmashellrc = File.read('config/includes.chroot/etc/skel/.config/plasmashellrc')
    expect(xdg_plasmashellrc).to match(/panelOpacity=1/)
    expect(skel_plasmashellrc).to match(/panelOpacity=1/)
  end

  it 'disables overview, blur, slide, and screen edge effects in kwinrc' do
    [
      'config/includes.chroot/etc/xdg/kwinrc',
      'config/includes.chroot/etc/skel/.config/kwinrc'
    ].each do |path|
      expect(File.exist?(path)).to be true
      content = File.read(path)
      expect(content).to match(/overviewEnabled=false/)
      expect(content).to match(/blurEnabled=false/)
      expect(content).to match(/slideEnabled=false/)
      expect(content).to match(/TopLeft=None/)
    end
  end

  it 'disables baloo search in krunnerrc' do
    [
      'config/includes.chroot/etc/xdg/krunnerrc',
      'config/includes.chroot/etc/skel/.config/krunnerrc'
    ].each do |path|
      expect(File.exist?(path)).to be true
      content = File.read(path)
      expect(content).to match(/baloosearchEnabled=false/)
    end
  end

  it 'configures Breeze Automatic theme in kdeglobals' do
    [
      'config/includes.chroot/etc/xdg/kdeglobals',
      'config/includes.chroot/etc/skel/.config/kdeglobals'
    ].each do |path|
      expect(File.exist?(path)).to be true
      content = File.read(path)
      expect(content).to match(/AutomaticLookAndFeel=true/)
      expect(content).to match(/LookAndFeelPackage=org\.kde\.breeze\.desktop/)
    end
  end

  it 'purges plasma-welcome from the live image in chroot setup hook' do
    hook_path = 'config/hooks/live/0100-hobby-setup.hook.chroot'
    expect(File.exist?(hook_path)).to be true
    content = File.read(hook_path)
    expect(content).to match(/apt-get purge -y plasma-welcome/)
  end
end


