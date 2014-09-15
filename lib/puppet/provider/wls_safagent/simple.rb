require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_safagent).provide(:simple) do
  include EasyType::Provider

  desc 'safagent server in an WebLogic domain via regular WLST'
  mk_resource_methods
end
