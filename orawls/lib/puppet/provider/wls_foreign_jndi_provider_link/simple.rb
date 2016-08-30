require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_foreign_jndi_provider_link).provide(:simple) do
  include EasyType::Provider

  desc 'Manage foreign JNDI provider links'
  mk_resource_methods
end
