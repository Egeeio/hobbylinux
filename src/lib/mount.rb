mount_point = '/mnt'
partition = 'sda1'
def mount()
  unless Dir.exist?(mount_point)
    Dir.mkdir(mount_point)
  end
  `mount #{partition} #{mount_point}`
end