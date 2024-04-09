DRIVE = 'sda'

def partition()
  create_partition_table()
  create_partition()
  create_file_system()
end

private

def create_partition_table()
  `echo -e "o\nw\n" | fdisk "/dev/#{DRIVE}"`
end

def create_partition()
  `echo -e "n\np\n1\n\n\nw\n" | fdisk "/dev/#{DRIVE}"`
end

def create_file_system()
  `mkfs.btrfs "/dev/#{DRIVE}1"`
end