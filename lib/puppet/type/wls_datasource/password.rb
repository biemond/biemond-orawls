require 'utils/wls_functions'

newproperty(:password) do
  include EasyType
  include Utils::WlsAccess
  include Utils::WlsFunctions

  desc <<-EOD
    The datasource password.

    There are two ways you can use this property:

    1. with an encrypted value
    2. with a clear text password

    Usage with a encrypted password:

        wls_datasource { ....:
          ...
          password => '{AES}yAf7w4hKUOa3XSUsPCPb1LWnwy0PSNiq7+HAahXXWQY=',
          ...
        }

    Puppet treats everything that starts with `{...}`, where the dots are uppercase letters,
    as an encrypted value. These values are passed directly to WebLogic and stored in the domain.

    A method to get the encrypted value would be:

    1. Set the password through the WebLogic management interface
    2. User `puppet resource wls_datasource datsource_name` to get all information including the 
       encrypted password.

    Usage with a clear text password:

        wls_datasource { ....:
          ...
          password => 'clear_text_password',
          ...
        }

    Clear text passwords are passed to WebLogic for encryption and then stored in the database.

  EOD

  def insync?(is)
    #
    # If the specified password in the manifest is encrypted, we compare it
    # with the fetched password (which is also encrypted). If the specified password 
    # is a plain text password, we ask WLS to decrypt is for us before comparing it to the
    # specified value.
    #
    if encrypted_password?
      is == should
    else
      wls_decrypt_value(is, resource) == should
    end
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
    raw_resource['password']
  end

  private
    #
    # If the password starts with {AES} or 3 other capitals between curly braces,
    # we treat the password as an encrypted value.
    #
    def encrypted_password?
      !should.scan(/\A\{[A-Z]{3}\}.*\Z/).empty?
    end

end
