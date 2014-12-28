#!/bin/bash

source ~/.profile
source ~/.rvm/scripts/rvm

rvm --version

# rvm install ruby-1.8.7
# rvm use ruby-1.8.7
# rvm install ruby-1.9.3
# rvm use ruby-1.9.3
rvm install ruby-2.0.0
rvm use ruby-2.0.0

set -e

ruby -v
echo "gem version"
gem --version
gem install bundler --no-rdoc --no-ri
bundle install --without development
bundle --version
gem update --system 2.1.11

bundle exec rake syntax
bundle exec rake lint
bundle exec rake ci:setup:rspec spec
bundle exec rubocop
#bundle exec rake spec

#ruby syntax check
rubocop


# Release the Puppet module, doing a clean, build, tag, push, bump_commit
rake module:clean
rake build

rake module:push
rake module:tag
rake module:bump_commit  # Bump version and git commit




# for windows
install ruby 1.9.3 for windows
install puppet 3.7.1 msi (https://downloads.puppetlabs.com/windows/)

gem install bundler --no-rdoc --no-ri
bundle install --without development
gem update --system 2.1.11

set PUPPET_VERSION=3.7.1
bundle update
SET PATH="C:\Program Files (x86)\Puppet Labs\Puppet\bin";"C:\Program Files (x86)\Puppet Labs\Puppet\facter\bin";"C:\Program Files (x86)\Puppet Labs\Puppet\hiera\bin";"C:\Program Files (x86)\Puppet Labs\Puppet\bin";"C:\Program Files (x86)\Puppet Labs\Puppet\sys\tools\bin";%PATH%
SET RUBYLIB="C:\Program Files (x86)\Puppet Labs\Puppet\lib";"C:\Program Files (x86)\Puppet Labs\Puppet\facter\lib";"C:\Program Files (x86)\Puppet Labs\Puppet\hiera\lib";%RUBYLIB%;

bundle exec rake syntax
bundle exec rake lint
bundle exec rake ci:setup:rspec spec


