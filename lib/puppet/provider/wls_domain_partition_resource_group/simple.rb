require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_domain_partition_resource_group).provide(:simple) do
  include EasyType::Provider

  desc 'Manage all the WebLogic 12.2.1 domain partition resource groups via regular WLST'
  mk_resource_methods
end
