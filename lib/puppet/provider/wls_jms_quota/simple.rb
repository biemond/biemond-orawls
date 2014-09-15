require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jms_quota).provide(:simple) do
  include EasyType::Provider

  desc 'Manage quotas of a JMS module in an WebLogic domain via regular WLST'
  mk_resource_methods
end
