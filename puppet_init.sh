#!/bin/bash

wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb

echo "Europe/London" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

sudo apt-get update
sudo apt-get -y install puppet-common

# Install modules required for custom setup
puppet module install puppetlabs/stdlib
puppet module install puppetlabs/apt
puppet module install puppetlabs/ntp
puppet module install puppetlabs/firewall
