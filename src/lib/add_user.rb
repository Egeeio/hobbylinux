# frozen_string_literal: true

require_relative 'helpers'

def add_user(user_name='hobby')
  stream_cmd('cp -f scripts/add_user.sh /mnt/root/add_user.sh')
  arch_chroot_runner("/root/add_user.sh #{user_name}")
end
