#!/bin/bash

function log() {
  echo "[+] $1"
}

function package() {
  if [[ -n "$(dpkg --get-selections | grep $1)" ]]; then
    log "$1 is already installed. skipping."
  else
    log "Installing $1"
    sudo DEBIAN_FRONTEND=noninteractive apt-get install $1 -y --no-install-recommends
  fi
}

function repo_osquery() {
  log "Adding osquery repository keys"
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
  sudo add-apt-repository "deb [arch=amd64] https://osquery-packages.s3.amazonaws.com/trusty trusty main"
}

function repo_mycli() {
  log "Adding MyCLI repository keys"
  curl -s https://packagecloud.io/gpg.key | sudo apt-key add -
  package apt-transport-https
  echo "deb https://packagecloud.io/amjith/mycli/ubuntu/ trusty main" | sudo tee -a /etc/apt/sources.list
}

function install_mysql() {
  local __pwd=$1

  log "Installing MySQL"

  echo "mysql-server-5.5 mysql-server/root_password password $__pwd" | sudo debconf-set-selections
  echo "mysql-server-5.5 mysql-server/root_password_again password $__pwd" | sudo debconf-set-selections
  package mysql-server
}

function install_nginx() {
  local __path=$1
  local __mode=$2

  package nginx
}

function repo_hhvm() {
  log "Adding HHVM key"
  sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
  log "Adding HHVM repo"
  sudo add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main"
}

function install_hhvm() {
  local __path=$1

  package hhvm

  log "Copying HHVM configuration"
  cat "$__path/extra/hhvm.conf" | sed "s|CTFPATH|$__path/|g" | sudo tee /etc/hhvm/server.ini

  log "HHVM as PHP systemwide"
  sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60

  log "Enabling HHVM to start by default"
  sudo update-rc.d hhvm defaults

  log "Restart HHVM"
  sudo service hhvm restart
}

function install_composer() {
  local __path=$1

  log "Installing composer"
  cd $__path
  curl -sS https://getcomposer.org/installer | php
  php composer.phar install
  sudo mv composer.phar /usr/bin
  sudo chmod +x /usr/bin/composer.phar
}