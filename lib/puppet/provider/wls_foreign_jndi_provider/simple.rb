require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_foreign_jndi_provider).provide(:simple) do
  include EasyType::Provider

  desc 'Manage foreign JNDI providers'
  mk_resource_methods
end
