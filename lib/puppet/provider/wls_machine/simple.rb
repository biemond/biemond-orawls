require 'easy_type'
require 'utils/wls_access'


Puppet::Type.type(:wls_machine).provide(:simple) do
	include EasyType::Provider

  desc "Manage machine in an WebLogic domain via regular WLST"

  mk_resource_methods

end

