require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_coherence_server).provide(:simple) do
  include EasyType::Provider

  desc 'Manage coherence server'
  mk_resource_methods
end
