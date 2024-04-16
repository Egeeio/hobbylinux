#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/partition'
require_relative 'lib/mount'
require_relative 'lib/bootstrap'
require_relative 'lib/desktop'
require_relative 'lib/add_user'
require 'optparse'

OptionParser.new do |opts|
  opts.banner = "Welcome to the Hobby Linux Installer! 🚀\nUsage: ./installer.rb [options]"

  opts.on('-i', '--install DISK', 'Install Hobby Linux on DISK') do |disk|
    partition(disk)
    mount(disk)
    bootstrap
    desktop
    add_user
    puts 'All Finished!'
    exit
  end

  opts.on('-h', '--help', 'Show this help message') do
    puts opts
    exit
  end
end.parse!
