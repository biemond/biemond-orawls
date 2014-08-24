require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_coherence_cluster).provide(:simple) do
	include EasyType::Provider

  desc "Manage coherence clusters"
  mk_resource_methods
end