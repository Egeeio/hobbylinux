#!/bin/sh
# /etc/profile.d/hobby-nala.sh
# Alias apt and apt-get to nala for interactive bash/sh sessions

if [ -t 0 ] && command -v nala >/dev/null 2>&1; then
    alias apt="nala"
    alias apt-get="nala"
fi
