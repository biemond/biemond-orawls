source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.0']

gem 'coveralls', :require => false
gem 'simplecov', :require => false
gem 'simplecov-console'

gem 'puppet-lint', :git => 'https://github.com/rodjek/puppet-lint'
gem 'puppet', puppetversion
gem 'rspec-puppet', '= 2.3.2'
gem 'puppetlabs_spec_helper'
gem 'metadata-json-lint'
gem 'puppet-syntax'
# gem 'facter', '>= 1.6.10'
gem 'ci_reporter_rspec'
gem 'rubocop', :git => 'https://github.com/bbatsov/rubocop',  :require => false
gem 'puppet-blacksmith'
# gem 'tins', '= 1.6.0'
