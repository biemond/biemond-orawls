require 'utils/wls_functions'

newproperty(:provider_specific) do
  include EasyType
  include Utils::WlsFunctions

  desc <<-EOD
    The provider specific properties.

    This value is a Hash that contains key's and values. Here is an example on how to use this:

        wls_authentication_provider { 'domain/MyLDAPAuthenticator':
          ...
          provider_specific   => {
            'ResultsTimeLimit' => 300,
            'SSLEnabled'       => 0,
            'Host'             => 'ldap.enterprisemodules.com',
            'ConnectTimeout'   => '5000',
          },
          providerclassname  => 'weblogic.security.providers.authentication.LDAPAuthenticator',
        }

      In this example the `ResultsTimeLimit`, `SSLEnabled`, `Host` and `ConnectTimeout` are the 
      provider-specific properties for the `weblogic.security.providers.authentication.LDAPAuthenticator` 
      class. In this example, we mix integer values and quoted integer values. It doesn't matter. Internally 
        all values are quoted and converted to their right representation.

      For the logical value `SSLEnabled`, you must use `0` for false and `1` for true. When you use the values
       `false` or `true`, the changes are not idempotent.

      When you specify a key value that the provider doesn't understand or a value that is invalid for the
      specific property, the puppet type will fail with the error 

      `Error: Failed to apply catalog: command in daemon failed.`

      **ATTENTION:**

      Most of the properties from the wls_authentication_provider need a restart from the Admin server. 
      If you don't restart the server, the changes will not be applied, and Puppet will redo them. 

  EOD

  defaultto({})

  def insync?(is)
    is.to_a.sort == should.to_a.sort
  end

  validate do | value|
    fail "should be a Hash value" unless value.is_a?(Hash)
  end

  #
  # Make sure the key and the values in the hashes are strings
  #
  munge do | value_hash|
    value_hash.each do | key, value|
      value_hash[key.to_s] = value.to_s
      if (value==nil or value=='')
        value_hash[key.to_s] = nil
      else
        value_hash[key.to_s] = value.to_s
      end
    end
    value_hash
  end

  def change_to_s(from, to)
    return_value = []
    realm_path = wls_get_realm_path('', provider)
    base_path = "#{realm_path}/AuthenticationProviders/#{resource['authentication_provider_name']}"
    from.keys.each do | property|
      if to[property] != from[property]      
        full_key = "#{base_path}/#{property}"
        #
        # If the key is encrypted, we don't show it's content
        #
        if wls_is_encrypted(full_key, provider) == '1'
          return_value << "property #{property} from [old value redacted] to [new value redacted]" 
        else
          return_value << "property #{property} from #{from[property]} to #{to[property]}"
        end
      end
    end
    "Changed #{return_value.join(' and ')}."
  end

end
