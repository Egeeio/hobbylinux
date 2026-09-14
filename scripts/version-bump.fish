#!/usr/bin/fish
source (status dirname)/../lib/hobbylib.fish

# TODO: Is there an easier way of bumping the versions all together :(

set -l action $argv[1]
test -z "$action"; and set action patch

set -l version_file "VERSION"
set -l branding_file "config/includes.chroot/etc/calamares/branding/hobby/branding.desc"
set -l os_release_file "config/includes.chroot/usr/lib/os-release"

set -l current_version (string trim (cat $version_file))
set -l parts (string split '.' $current_version)
set -l major $parts[1]
set -l minor $parts[2]
set -l patch $parts[3]

set -l new_version
switch $action
    case patch
        set -l new_patch (math $patch + 1)
        set new_version "$major.$minor.$new_patch"
    case minor
        set -l new_minor (math $minor + 1)
        set new_version "$major.$new_minor.0"
    case major
        set -l new_major (math $major + 1)
        set new_version "$new_major.0.0"
    case '*'
        set new_version "$action"
end

echo "$new_version" > $version_file

if test -f $branding_file
    sed -i "s/^[[:space:]]*version:[[:space:]]*.*/    version:             $new_version/" $branding_file
    sed -i "s/^[[:space:]]*shortVersion:[[:space:]]*.*/    shortVersion:        $new_version/" $branding_file
    sed -i "s/^[[:space:]]*versionedName:[[:space:]]*.*/    versionedName:       Hobby Linux $new_version/" $branding_file
    sed -i "s/^[[:space:]]*shortVersionedName:[[:space:]]*.*/    shortVersionedName:  Hobby $new_version/" $branding_file
end

if test -f $os_release_file
    sed -i "s/^PRETTY_NAME=\"Hobby Linux .*\"/PRETTY_NAME=\"Hobby Linux $new_version\"/" $os_release_file
    sed -i "s/^VERSION_ID=\".*\"/VERSION_ID=\"$new_version\"/" $os_release_file
    sed -i "s/^VERSION=\".*\"/VERSION=\"$new_version\"/" $os_release_file
end

log_info "Bumped version: $current_version -> $new_version"
