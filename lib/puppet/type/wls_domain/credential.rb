require 'utils/wls_functions'

newproperty(:credential) do
  include EasyType
  include Utils::WlsAccess
  include Utils::WlsFunctions

  desc <<-EOD
    The domain credential.

    Usage :

        wls_domain { ....:
          ...
          credential => 'clear_text_password',
          ...
        }

    The credential string is passed to WebLogic for encryption and then stored in the domain.

  EOD

  def insync?(is)
    current_credential == should
  end

  def change_to_s(currentvalue, newvalue)
    if currentvalue == :absent
      "created with specified value"
    else
      "changed to new value"
    end
  end

  def is_to_s(currentvalue)
    '[old credential redacted]'
  end

  def should_to_s(newvalue)
    '[new credential redacted]'
  end

  to_translate_to_resource do | raw_resource|
    '<encrypted credential>'
  end

  def current_credential
    #
    # Puppet asks Weblogic to decrypt the current domain credential stored in the domain and 
    # return this to puppet for comparison. The Puppet code does not store the decrypted password
    # on disk.
    #
    weblogic_domain_name = resource[:weblogic_domain_name]
    key = "SecurityConfiguration/#{weblogic_domain_name}/CredentialEncrypted"
    wls_get_password(key, resource)
  end

end
