require 'easy_type'
require 'utils/wls_access'
require 'utils/wls_functions'

Puppet::Type.type(:wls_authentication_provider).provide(:prefetching) do
  include EasyType::Provider
  include EasyType::Template
  include EasyType::Helpers
  include Utils::WlsAccess
  extend Utils::WlsFunctions

  desc 'Manage wls_authentication_providers'

  mk_resource_methods

  def self.prefetch(resources)
    objects = instances
    resources.keys.each do |name|
      current_resource = resources[name]
      provider = instances.find { |i| i.name == name }
      if provider
        current_resource.provider = provider
        realm_path = wls_get_realm_path('', provider)
        base_path = "#{realm_path}/AuthenticationProviders/#{current_resource['authentication_provider_name']}"
        #
        # Fetch all provider specific keys
        #
        provider.property_hash[:provider_specific] = {}
        current_resource['provider_specific'].keys.each do |key|
          begin
            full_key = "#{base_path}/#{key}"
            #
            # If the key is encrypted, we fetch the encrypted key and decrypt the value
            #
            if wls_is_encrypted(full_key, provider) == '1'
              encrypted_key = "#{full_key}Encrypted"
              provider.property_hash[:provider_specific][key] = wls_get_password(encrypted_key, provider)
            else
              provider.property_hash[:provider_specific][key] = wls_get_value(full_key, provider)
            end
          rescue RuntimeError => e
            fail "Error fetching value for property: '#{key}' while in #{provider}. Probably an unknown  propery."
          end
        end
      end
    end
  end

end
