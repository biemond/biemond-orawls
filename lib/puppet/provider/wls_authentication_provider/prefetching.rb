require 'easy_type'
require 'utils/wls_access'

Puppet::Type.type(:wls_authentication_provider).provide(:prefetching) do
  include EasyType::Provider
  include EasyType::Template
  include EasyType::Helpers
  include Utils::WlsAccess

  desc 'Manage wls_authentication_providers'

  mk_resource_methods

  def self.prefetch(resources)
    objects = instances
    resources.keys.each do |name|
      current_resource = resources[name]
      provider = instances.find { |i| i.name == name }
      if provider
        current_resource.provider = provider
        environment = { 'action' => 'execute', 'type' => :wls_authentication_provider }
        values = wlst template('puppet:///modules/orawls/providers/wls_authentication_provider/fetch.py.erb', binding), environment
        provider.property_hash[:provider_specific] = values.first
      end
    end
  end

end
