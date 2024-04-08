#!/usr/bin/env ruby
require 'optparse'
require_relative 'lib/partition'
require_relative 'lib/mount'
require_relative 'lib/bootstrap'
require_relative 'lib/desktop'
require_relative 'lib/adduser'

OptionParser.new do |opts|
    opts.banner = "Welcome to the Hobby Linux Installer! 🚀\nUsage: ./installer [options]"

    opts.on("-i", "--install", "Install Hobby Linux") do |v|
      partition()
      mount()
      bootstrap()
      exit
    end

    opts.on("-h", "--help", "Show this help message") do
      puts opts
      exit
    end
  end.parse!