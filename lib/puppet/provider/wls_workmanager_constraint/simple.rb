require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_workmanager_constraint).provide(:simple) do
	include EasyType::Provider

  desc "Manage workmanager constraint of a WebLogic domain"
  mk_resource_methods
end