def mount(disk)
  `mount /dev/#{disk}1 /mnt`
end