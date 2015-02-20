require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jms_bridge_destination).provide(:simple) do
  include EasyType::Provider

  desc 'Manage a JMS bridge destinaion in an WebLogic domain via regular WLST'
  mk_resource_methods
end
