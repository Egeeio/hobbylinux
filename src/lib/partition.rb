# frozen_string_literal: true

def partition(disk)
  puts `echo -e "o\nw\n" | fdisk "/dev/#{disk}"`
  puts `echo -e "n\np\n1\n\n\nw\n" | fdisk "/dev/#{disk}"`
  # puts `mkfs.xfs -f "/dev/#{disk}1"`
  puts `mkfs.btrfs -f "/dev/#{disk}1"`
end
