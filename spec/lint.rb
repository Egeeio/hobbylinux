require 'yaml'
  errors = []

  yaml_files = Dir.glob('config/includes.chroot/etc/calamares/**/*.conf') + Dir.glob('config/includes.chroot/etc/calamares/**/*.yaml')
  puts 'Checking YAML syntax...'
  yaml_files.each do |file|
    begin
      YAML.safe_load_file(file, aliases: true)
      puts "  #{file}"
    rescue Psych::SyntaxError => e
      errors << "  YAML syntax error in #{file}:\n#{e.message}"
    rescue => e
      errors << "  Error reading #{file}:\n#{e.message}"
    end
  end

  all_scripts = Dir.glob('config/hooks/**/*') +
                Dir.glob('config/includes.chroot/usr/local/bin/**/*') +
                Dir.glob('config/includes.chroot/usr/local/lib/**/*') +
                Dir.glob('*.sh') +
                Dir.glob('*.fish')
  all_scripts = all_scripts.select { |f| File.file?(f) }.uniq

  sh_files = all_scripts.select do |file|
    file.end_with?('.sh') || (File.size(file) > 15 && File.read(file, 20).match?(%r{^#!/(bin|usr/bin)/(sh|bash)}))
  end

  if sh_files.any?
    puts "\nRunning ShellCheck on shell scripts..."
    sh_files.each do |file|
      if system('shellcheck', file)
        puts "  #{file}"
      else
        errors << "  ShellCheck failed for #{file}"
      end
    end
  end

  fish_files = all_scripts.select do |file|
    file.end_with?('.fish') || (File.size(file) > 15 && File.read(file, 20).include?('#!/usr/bin/fish'))
  end

  if fish_files.any?
    puts "\nChecking Fish syntax..."
    fish_files.each do |file|
      if system('fish', '-n', file)
        puts "  #{file}"
      else
        errors << "  Fish syntax error in #{file}"
      end
    end
  end


  if errors.any?
    puts "\n"
    errors.each { |err| puts err }
    abort "\nLinting failed with #{errors.size} error(s)"
  else
    puts "\nAll files passed linting."
  end