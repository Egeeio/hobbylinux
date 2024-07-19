#!/usr/bin/env bash
# set -eux
OUTDIR='outdir'
WORKDIR='workdir'
PROFILEDIR='profile'

sudo mkarchiso -v \
  -o "./$OUTDIR"  \
  -w "./$WORKDIR" \
     "./$PROFILEDIR"
sudo chown -R "$USER" .
rm -rf ./workdir
touch ./workdir/.gitkeep