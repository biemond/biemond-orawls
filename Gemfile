source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.0']

platform :ruby_19, :ruby_20 do
  gem 'coveralls', :require => false
  gem 'simplecov', :require => false
end
gem 'puppet-lint'
gem 'puppet', puppetversion
gem 'rspec-puppet', :github =>'rodjek/rspec-puppet'
gem 'rspec-system-puppet'
gem 'puppetlabs_spec_helper'
gem 'puppet-syntax'
gem 'facter', '>= 1.6.10'
