require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_migratable_target).provide(:simple) do
  include EasyType::Provider

  desc 'Manage a migratable target of a WebLogic domain via regular WLST'
  mk_resource_methods
end

