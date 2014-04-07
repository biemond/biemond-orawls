require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_user).provide(:simple) do
	include EasyType::Provider

  desc "Manage users of a WebLogic Security REALM"
  mk_resource_methods
end