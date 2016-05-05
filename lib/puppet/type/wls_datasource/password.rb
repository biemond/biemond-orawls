require 'utils/wls_functions'

newproperty(:password) do
  include EasyType
  include Utils::WlsAccess
  include Utils::WlsFunctions

  desc <<-EOD
    The datasource password.

    Usage :

        wls_datasource { ....:
          ...
          password => 'clear_text_password',
          ...
        }

    The password string is passed to WebLogic for encryption and then stored in the domain.

  EOD

  def insync?(is)
    current_password == should
  end

  def change_to_s(currentvalue, newvalue)
    if currentvalue == :absent
      "created with specified value"
    else
      "changed to new value"
    end
  end

  def is_to_s(currentvalue)
    '[old password redacted]'
  end

  def should_to_s(newvalue)
    '[new password redacted]'
  end

  to_translate_to_resource do | raw_resource|
    '<encrypted password>'
  end

  def current_password
    #
    # Puppet asks Weblogic to decrypt the current datasource password stored in the domain and 
    # return this to puppet for comparison. The Puppet code does not store the decrypted password
    # on disk.
    #
    datasource_name = resource[:datasource_name]
    key = "JDBCSystemResources/#{datasource_name}/JDBCResource/#{datasource_name}/JDBCDriverParams/#{datasource_name}/PasswordEncrypted"
    wls_get_password(key, resource)
  end

end
