require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_identity_asserter).provide(:simple) do
  include EasyType::Provider

  desc 'Manage identity asserters in an WebLogic domain via regular WLST'
  mk_resource_methods
end
