require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_authentication_provider).provide(:simple) do
  include EasyType::Provider

  desc 'Manage authentication providers in an WebLogic domain via regular WLST'
  mk_resource_methods
end
