require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_messaging_bridge).provide(:simple) do
  include EasyType::Provider

  desc 'Manage a Messaging bridge in an WebLogic domain via regular WLST'
  mk_resource_methods
end
