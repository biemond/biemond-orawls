require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_multi_datasource).provide(:simple) do
  include EasyType::Provider

  desc 'Manage a multi datasource in an WebLogic domain via regular WLST'
  mk_resource_methods
end
