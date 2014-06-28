#!/usr/bin/env bash

#
# We need to install vagrant + berkshelf to start the bootstrapping of system
#

# install base packages
yum -y install libyaml-devel

# install rvm
\curl -sSL https://get.rvm.io | bash -s stable --ruby

# install vagrant
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.rpm
rpm -Uvh vagrant_1.6.3_x86_64.rpm
rm vagrant_1.6.3_x86_64.rpm

# install vagrant plugins
vagrant plugin install vagrant-host-shell
vagrant plugin install vagrant-berkshelf
