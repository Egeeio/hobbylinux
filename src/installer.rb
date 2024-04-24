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
    disk = args[0]
    user = args[1]
  end
  disk ||= 'sda'
  user ||= 'hobby'
  puts "Installing to #{disk} with user #{user}."
  puts "Install will begin in 5 seconds..."
  sleep 5
  partition(disk)
  mount(disk)
  bootstrap
  desktop(user)
  passwd = add_user(user)
  puts "Installation Complete.\nReboot into Hobby Linux and log in as:\nUsername: #{user}\nOne-time password: #{passwd}"
end.parse!
