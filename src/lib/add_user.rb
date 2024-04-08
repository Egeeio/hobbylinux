def add_user(user_name='hobby')
  puts `cp -f scripts/add_user.sh /mnt/root/add_user.sh`
  puts `arch-chroot /mnt /bin/bash -c "/root/add_user.sh #{user_name}"`
end
