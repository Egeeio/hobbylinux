# frozen_string_literal: true

def stream_cmd(cmd)
  IO.popen(cmd) do |io|
    while line = io.gets
      puts line.chomp
    end
  end
end

def arch_chroot_runner(cmd, chroot = '/mnt')
  chroot_cmd = "arch-chroot #{chroot} /bin/bash -c '#{cmd}'"
  stream_cmd(chroot_cmd)
end

def pacman_install(pkgs, update = nil)
  cmd = 'pacman --noconfirm -S'
  "#{cmd}y" if update
  arch_chroot_runner("#{cmd} #{pkgs}")
end

def sed(original, replacement, file_uri)
  arch_chroot_runner("sed -i 's/#{original}/#{replacement}/' #{file_uri}")
end

def activate_service(srv, start = nil)
  cmd = 'systemctl enable'
  "#{cmd} --now" if start
  arch_chroot_runner("#{cmd} #{srv}")
end
