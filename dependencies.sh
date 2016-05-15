#!/bin/bash

P_ROOT="root"
MODE="prod"
CTF_PATH="/var/www/fbctf"

mkdir -p "$CTF_PATH"

# There we go!
source "/root/lib.sh"

# Off to a good start...
package language-pack-en
package emacs

# Adding repos for osquery (of course!), mycli and hhvm
repo_osquery
repo_mycli

# We only run this once so provisioning is faster
sudo apt-get update

# Install osquery and mycli
package osquery
package mycli

# Install memcached
package memcached

# Install htop
package htop

# Install MySQL
install_mysql "$P_ROOT"

# Install git
package git

# Install NPM and grunt
package npm
package nodejs-legacy

# Install nginx
install_nginx "$CTF_PATH" "$MODE"

log 'fbctf_base init is complete!'

exit 0
