#!/bin/sh

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/etc/puppet/

# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt or yum

install_git() {
  echo 'Attempting to install git.'
  $(which apt-get > /dev/null 2>&1)
  FOUND_APT=$?
  $(which yum > /dev/null 2>&1)
  FOUND_YUM=$?

  if [ "${FOUND_YUM}" -eq '0' ]; then
    yum -q -y makecache
    yum -q -y install git-core
    echo 'git installed.'
  elif [ "${FOUND_APT}" -eq '0' ]; then
    apt-get -q -y update
    apt-get -q -y install git-core
    echo 'git installed.'
  else
    echo 'No package installer available. You may need to install git manually.'
  fi
}

install_ruby() {
echo 'Attempting to install ruby.'
  $(which apt-get )
  FOUND_APT=$?
  $(which yum > /dev/null 2>&1)
  FOUND_YUM=$?

  if [ "${FOUND_YUM}" -eq '0' ]; then
    yum -q -y install ruby19 ruby-rdoc ruby-devel rubygems 
    alternatives --set ruby /usr/bin/ruby1.9
	alternatives --set gem /usr/bin/gem1.9
    echo 'ruby installed.'
  elif [ "${FOUND_APT}" -eq '0' ]; then
    echo 'Attempting to install ruby.'
    apt-get -q -y install ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 irb1.9.1 ri1.9.1 rdoc1.9.1 build-essential libopenssl-ruby1.9.1 libssl-dev zlib1g-dev
    update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400 \
         --slave   /usr/share/man/man1/ruby.1.gz ruby.1.gz \
                        /usr/share/man/man1/ruby1.9.1.1.gz \
        --slave   /usr/bin/ri ri /usr/bin/ri1.9.1 \
        --slave   /usr/bin/irb irb /usr/bin/irb1.9.1 \
        --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1

    update-alternatives --config ruby
    update-alternatives --config gem	
    echo 'ruby installed.'
  else
    echo 'No package installer available. You may need to install ruby manually.'
  fi
}

echo "checking for git ..."
$(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
  install_git
else
  echo 'git found.'
fi

echo "checking for ruby..."
$(which ruby > /dev/null 2>&1)
FOUND_RUBY=$?
if [ "$FOUND_RUBY" -ne '0' ]; then
  install_ruby
else
  echo 'ruby found.'
  $(ruby --version | grep 1\.9 > /dev/null 2>&1)
  FOUND_RUBY_1_9=$?
  if [ "$FOUND_RUBY_1_9" -ne '0' ]; then
    echo "version of ruby not 1.9, attempting to install"
    install_ruby
  else
    echo "ruby already installed"
  fi
fi  

echo "checking for puppet..."
$(which puppet > /dev/null 2>&1)
FOUND_PUPPET=$?
if [ "$FOUND_PUPPET" -ne '0' ]; then
  gem install puppet
else
  echo 'puppet found.'
fi

if [ ! -d "$PUPPET_DIR" ]; then
  mkdir -p $PUPPET_DIR
fi
cp /vagrant/puppet/Puppetfile $PUPPET_DIR

if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  gem install librarian-puppet
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  cd $PUPPET_DIR && librarian-puppet update
fi


