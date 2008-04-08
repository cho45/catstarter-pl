#!/usr/bin/sh

chmod 0755 ./script/*.pl

git init
git add .
git rm -f startup.sh
git commit -m 'init'

