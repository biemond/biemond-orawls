require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_saf_remote_context).provide(:simple) do
	include EasyType::Provider

  desc "saf remote context in a JMS module of an WebLogic domain via regular WLST"
  mk_resource_methods
end