require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_server_channel).provide(:simple) do
  include EasyType::Provider

  desc 'Manage server channels in an WebLogic domain via regular WLST'
  mk_resource_methods
end
