require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_mail_session).provide(:simple) do
	include EasyType::Provider

  desc "Manage a mail session in an WebLogic domain via regular WLST"
  mk_resource_methods
end