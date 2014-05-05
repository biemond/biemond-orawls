require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'mocha'
fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
# include common helpers
support_path = File.expand_path(File.join(File.dirname(__FILE__), '..',
                                          'spec/support/*.rb'))
Dir[support_path].each {|f| require f}

RSpec.configure do |c|
  c.config = '/doesnotexist'
  # c.manifest_dir = File.join(fixture_path, 'manifests')
  c.module_path  = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/modules'))
  # Using an empty site.pp file to avoid: https://github.com/rodjek/rspec-puppet/issues/15
  c.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/manifests'))
  c.mock_with :mocha
end

def param_value(subject, type, title, param)
  subject.resource(type, title).send(:parameters)[param.to_sym]
end

#at_exit { RSpec::Puppet::Coverage.report! }