# frozen_string_literal: true

require_relative 'helpers'

def bootstrap
  stream_cmd('pacstrap -K /mnt grub efibootmgr')
end
