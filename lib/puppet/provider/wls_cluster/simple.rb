require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_cluster).provide(:simple) do
	include EasyType::Provider

  desc "Manage a cluster in an WebLogic domain via regular WLST"
  mk_resource_methods
end