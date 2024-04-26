#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/partition'
require_relative 'lib/mount'
require_relative 'lib/bootstrap'
require_relative 'lib/desktop'
require_relative 'lib/add_user'
require 'optparse'

OptionParser.new do |opts|
  opts.banner = "Welcome to the Hobby Linux Installer! 🚀\nUsage: ./installer.rb -i [DISK],[USERNAME]"
  opts.on('-h', '--help', 'Show this help message') do
    puts opts
    exit
  end
  opts.on('-i DISK USER', Array, 'Install Hobby Linux on DISK with USER') do |args|
    disk = args[0] || 'sda'
    user = args[1] || 'hobby'
    puts "Installing to #{disk} with user #{user}."
    puts "Install will begin in 5 seconds..."
    sleep 5
    partition(disk)
    mount(disk)
    bootstrap
    passwd = add_user(user)
    desktop(user)
    puts "Installation Complete.\nReboot into Hobby Linux and log in as:\nUsername: #{user}\nOne-time password: #{passwd}"
  end
end.parse!
