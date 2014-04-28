require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_workmanager).provide(:simple) do
	include EasyType::Provider

  desc "Manage workmanagers of a WebLogic domain"
  mk_resource_methods
end