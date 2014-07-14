#!/bin/bash

#
# http://askubuntu.com/questions/459402/how-to-know-if-the-running-platform-is-ubuntu-or-centos-with-help-of-a-bash-scri
# http://geekbraindump.blogspot.com/2010/06/case-insensitive-regex-in-bash.html

#
# Determine OS platform
UNAME=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
if [ "$UNAME" == "linux" ]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    else
        export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    fi
fi

# setup ubuntu dependencies
shopt -s nocasematch
if [[ "$DISTRO" =~ "ubuntu" ]]; then
  continue

# setup centOS dependencies
elif [[ "$DISTRO" =~ "centos" ]]; then
  wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
  wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
  sudo rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
  sudo yum install -y libyaml-devel

  rm remi-release-6*.rpm
  rm epel-release-6-8.noarch.rpm

# os not supported yet
else
  echo 'operating system not supported'
  exit 1
fi

# install rvm and add source
\curl -L https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
RVM_SOURCE=$(cat ~/.bashrc | grep '.rvm/scripts/rvm' | wc -l)
if [ $RVM_SOURCE -ge 1 ];
then
  echo '-- not adding rvm source entry'
else
  echo '-- adding rvm source entry'
  echo "source $HOME/.rvm/scripts/rvm" >> ~/.bashrc
fi

# install required dependencies
gem install berkshelf chef

# install cookbooks dependencies
berks

echo -e "\e[0m---"
echo -e ""
echo -e "\e[97m\e[40m\e[1mTo start the bootstrap in this terminal, you need to run \`source /home/$USER/.rvm/scripts/rvm\`"
echo -e ""
echo -e "\e[0m---"
