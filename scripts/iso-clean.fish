#!/usr/bin/fish
source (status dirname)/../lib/hobbylib.fish

# Clever feels like ruby kinda
for file in build/hobbylinux-*
    rm -rf $file
end
