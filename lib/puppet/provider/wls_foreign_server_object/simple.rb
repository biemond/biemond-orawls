require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_foreign_server_object).provide(:simple) do
	include EasyType::Provider

  desc "Foreign Server object in a JMS module of an WebLogic domain via regular WLST"
  mk_resource_methods
end