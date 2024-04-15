def partition(disk)
  create_partition_table(disk)
  create_partition(disk)
  create_file_system(disk)
end

private

def create_partition_table(disk)
  `echo -e "o\nw\n" | fdisk "/dev/#{disk}"`
end

def create_partition(disk)
  `echo -e "n\np\n1\n\n\nw\n" | fdisk "/dev/#{disk}"`
end

def create_file_system(disk)
  `mkfs.btrfs "/dev/#{disk}1"`
end