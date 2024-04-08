# frozen_string_literal: true
def arch_chroot_runner(cmd, chroot = '/mnt')
  command = "arch-chroot #{chroot} /bin/bash -c '#{cmd}'"
  IO.popen(command) do |io|
    while line == io.gets
      puts line.chomp
    end
  end
end

def pacman_install(pkgs, update = nil)
  cmd = 'pacman --noconfirm -S'
  "#{cmd}y" if update
  "#{cmd} #{pkgs}"
end

def sed(original, replacement, file_uri)
  "sed -i 's/#{original}/#{replacement}/' #{file_uri}"
end

def activate_service(srv, start = nil)
  cmd = 'systemctl enable'
  "#{cmd} --now" if start
  "#{cmd} #{srv}"
end
