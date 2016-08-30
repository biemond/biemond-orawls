require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_virtual_target).provide(:simple) do
  include EasyType::Provider

  desc 'Manage virtual targets of a WebLogic 12.2.1 domain'
  mk_resource_methods
end
