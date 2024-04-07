#!/usr/bin/env ruby
require 'optparse'

options = {}

OptionParser.new do |opts|
    opts.banner = "Welcome to the Hobby Linux Installer! 🚀\nUsage: ./installer [options]"
  
    opts.on("-i", "--install", "Install Hobby Linux") do |v|
      puts "It's installed!"
      exit
    end
  
    opts.on("-d", "--debug", "Run in debug mode") do |v|
      options[:debug] = v
    end
  
    opts.on("-h", "--help", "Show this help message") do
      puts opts
      exit
    end
  end.parse!