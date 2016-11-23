require 'simplecov'
require 'coveralls'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'simplecov-console'

Coveralls.wear!

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do

  add_group "Puppet Types", '/lib/puppet/type/'
  add_group "Puppet Providers", '/lib/puppet/provider/'
  add_group "Puppet Functions", 'lib/puppet/parser/functions/'
  add_group "Facts", 'lib/facter'

  add_filter '/spec'
  add_filter '/.vendor/'

  track_files 'lib/**/*.rb'
end

support_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec/support/*.rb'))
Dir[support_path].each { |f| require f }

RSpec.configure do |c|
  c.config = '/doesnotexist'
  c.module_path  = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/modules'))
  c.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/manifests'))
end

def param_value(subject, type, title, param)
  subject.resource(type, title).send(:parameters)[param.to_sym]
end

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

dir = Pathname.new(__FILE__).parent
Puppet[:modulepath] = File.join(dir, 'fixtures', 'modules')
Puppet[:libdir] = "#{Puppet[:modulepath]}/easy_type/lib"

def param_value(subject, type, title, param)
  subject.resource(type, title).send(:parameters)[param.to_sym]
end

at_exit { RSpec::Puppet::Coverage.report! }