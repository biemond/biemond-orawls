require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_resource_group_template).provide(:simple) do
  include EasyType::Provider

  desc 'Manage resource group template of a WebLogic 12.2.1 domain'
  mk_resource_methods
end
