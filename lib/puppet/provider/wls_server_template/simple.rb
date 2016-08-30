require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_server_template).provide(:simple) do
  include EasyType::Provider

  desc 'Manage server template for dynamic clusters'
  mk_resource_methods
end
