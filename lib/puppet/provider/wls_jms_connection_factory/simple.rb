require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jms_connection_factory).provide(:simple) do
	include EasyType::Provider

  desc "Manage JMS connection factories"
  mk_resource_methods
end