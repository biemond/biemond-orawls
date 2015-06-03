require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jdbc_persistence_store).provide(:simple) do
  include EasyType::Provider

  desc 'Manage JDBC persistence stores'
  mk_resource_methods
end
