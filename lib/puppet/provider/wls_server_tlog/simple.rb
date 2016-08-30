require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_server_tlog).provide(:simple) do
  include EasyType::Provider

  desc 'Manage tlog config on server in an WebLogic domain via regular WLST'
  mk_resource_methods
end
