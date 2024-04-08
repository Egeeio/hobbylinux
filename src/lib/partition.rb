DRIVE = 'sda'

def partition
  list_drives
end

# private

def list_drives
  `fdisk -l`
end

def create_partition_table
  `echo -e "o\nw\n" | fdisk "/dev/#{DRIVE}"`
end

def create_partition
  `echo -e "n\np\n1\n\n\nw\n" | fdisk "/dev/#{DRIVE}"`
end

def create_file_system
  `mkfs.btrfs "/dev/#{DRIVE}1"`
end