# frozen_string_literal: true

require_relative 'helpers'

def mount(disk)
  stream_cmd("mount /dev/#{disk}1 /mnt")
end