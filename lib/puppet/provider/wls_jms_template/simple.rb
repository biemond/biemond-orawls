require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jms_template).provide(:simple) do
  include EasyType::Provider

  desc 'Manage JMS connection templates'
  mk_resource_methods
end
