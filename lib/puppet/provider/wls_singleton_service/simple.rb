require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_singleton_service).provide(:simple) do
  include EasyType::Provider

  desc 'Manage a singleton service of a WebLogic domain via regular WLST'
  mk_resource_methods
end

