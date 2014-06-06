require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_deployment).provide(:simple) do
	include EasyType::Provider

  desc "Manage a deployment in an WebLogic domain via regular WLST"
  mk_resource_methods
end