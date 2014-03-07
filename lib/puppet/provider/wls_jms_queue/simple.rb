require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jms_queue).provide(:simple) do
	include EasyType::Provider

  desc "Manage a queue in a JMS module of an WebLogic domain via regular WLST"
  mk_resource_methods
end