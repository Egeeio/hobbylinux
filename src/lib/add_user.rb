# frozen_string_literal: true

require 'securerandom'
require_relative 'helpers'

def add_user(user_name = 'hobby')
  passwd = user_name # SecureRandom.hex[-5..]
  puts `cp -f scripts/add_user.sh /mnt/root/add_user.sh`
  arch_chroot_runner("/root/add_user.sh #{user_name} #{passwd}")
  passwd
end
