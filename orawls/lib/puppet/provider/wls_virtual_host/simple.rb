require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_virtual_host).provide(:simple) do
  include EasyType::Provider

  desc 'Manage virtual hosts of a WebLogic domain'
  mk_resource_methods
end
