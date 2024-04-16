# The \n's make the ``'s difficult to convert to stream_cmd
def partition(disk)
  puts `echo -e "o\nw\n" | fdisk "/dev/#{disk}"`
  puts `echo -e "n\np\n1\n\n\nw\n" | fdisk "/dev/#{disk}"`
  puts `mkfs.btrfs "/dev/#{disk}1"`
end