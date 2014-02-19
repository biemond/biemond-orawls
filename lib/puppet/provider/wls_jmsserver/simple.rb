require 'easy_type'
require 'utils/wls_access'


Puppet::Type.type(:wls_jmsserver).provide(:simple) do
	include EasyType::Provider

  desc "JMS server in an WebLogic domain via regular WLST"


  mk_resource_methods

end

