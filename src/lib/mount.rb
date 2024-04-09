def mount(mount_point='/mnt', partition='/dev/sda1')
  unless Dir.exist?(mount_point)
    Dir.mkdir(mount_point)
  end
  `mount #{partition} #{mount_point}`
end