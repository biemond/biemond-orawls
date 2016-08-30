require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_jms_security_policy).provide(:simple) do
  include EasyType::Provider

  desc 'Manage security policies of a JMS resource (queue or topic) via regular WLST'
  mk_resource_methods
end
