#!/usr/bin/sh

chmod 0755 ./script/*.pl
chmod 0755 ./migrate.pl
chmod 0755 ./worker.pl

git init
git add .
git rm -f startup.sh
git commit -m 'init'

