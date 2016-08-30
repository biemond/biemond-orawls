begin
  require 'coveralls'
  Coveralls.wear!

rescue LoadError
  puts "No Coveralls support"
end

require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'pathname'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
# include common helpers
support_path = File.expand_path(File.join(File.dirname(__FILE__), '..','spec/support/*.rb'))
Dir[support_path].each {|f| require f}

RSpec.configure do |c|
  c.config = '/doesnotexist'
  c.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/manifests'))
end

dir = Pathname.new(__FILE__).parent
Puppet[:modulepath] = File.join(dir, 'fixtures', 'modules')
Puppet[:libdir] = "#{Puppet[:modulepath]}/easy_type/lib"

def param_value(subject, type, title, param)
  subject.resource(type, title).send(:parameters)[param.to_sym]
end

#at_exit { RSpec::Puppet::Coverage.report! }
