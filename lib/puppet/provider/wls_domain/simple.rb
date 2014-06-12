require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_domain).provide(:simple) do
	include EasyType::Provider

  desc "Manage all the WebLogic domain options via regular WLST"
  mk_resource_methods
end