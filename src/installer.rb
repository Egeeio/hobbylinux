#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/partition'
require_relative 'lib/mount'
require_relative 'lib/bootstrap'
require_relative 'lib/desktop'
require_relative 'lib/add_user'
require 'optparse'

OptionParser.new do |opts|
  disk = 'sda'
  user = 'hobby'
  opts.on('-i DISK USER', Array, 'Install Hobby Linux on DISK with USER') do |args|
    disk = args[0]
    user = args[1]
  end
  partition(disk)
  mount(disk)
  bootstrap
  desktop(user)
  passwd = add_user(user)
  puts "Installation Complete.\nReboot into Hobby Linux and log in as:\nUsername: #{user}\nOne-time password: #{passwd}"

  opts.on('-h', '--help', 'Show this help message') do
    puts opts
  end
  opts.banner = "Welcome to the Hobby Linux Installer! 🚀\nUsage: ./installer.rb [DISK],[USER]"
end.parse!
