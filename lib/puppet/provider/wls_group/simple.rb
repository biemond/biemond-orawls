require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_group).provide(:simple) do
	include EasyType::Provider

  desc "Manage groups of a WebLogic Security REALM"
  mk_resource_methods
end