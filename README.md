# Hobby Linux Installer

Welcome to the Hobby Linux installer repository!

Here is where you will find tools and scripts pertaining to the installation and overall development of Hobby Linux.

**Hobby Linux is in a pre-alpha state.** The tools in this repo are not meant to be used, operated, or otherwise run on a live system with production data.

## Getting Started

Hobby Linux Installer simply turns Arch Linux into Hobby Linux. It's effectively an Arch install script! It is designed to be used in a <u>live arch iso environment as root</u>.

The installer is self-documenting; simply run `src/installer.rb --help` to see what it can do.

The most common usecase is a full install. Running `bin/installer.rb install` will result in a barebones Hobby Linux system with the user & password as: `hobby`.

## Future Plans

The Hobby Linux Installer's sole purpose is to install a functional Linux system that is ready to take on any or all of your hobbies.

At some point, the installer will be rewritten to accept input so that a user may install a system with their own user. This will also enable the creation of an gui-based installer.
