require 'utils/indent'
require 'utils/wls_access'

module Utils
  #
  # This module contains all WLS functions that can be directly called from ruby. These
  # functions must return one value. Because all functions are called within the context of
  # a resource in a domain. All functions must pass the current resource.
  #
  module WlsFunctions
    include Utils::WlsAccess

    wls_functions = [
      :wls_get_value,       # get the value at a specified key
      :wls_get_password,    # get the decrypted password string at a specified key.
      :wls_get_realm_path,  # Get the path of the default realm
      :wls_is_encrypted,    # Check if the specified attribute is encrypted
    ]

    wls_functions.each do | method_name|
      define_method(method_name) do |value, resource|
        wls_function(method_name, binding)
      end
    end

private

    def wls_function(method_name, caller_binding)
      environment = { 'action' => 'execute', 'type' => :wls_functions }
      function_content = template("puppet:///modules/orawls/functions/#{method_name}.py.erb", caller_binding)
      function_content = function_content.indent(4)
      resource = eval('resource', caller_binding)
      value = wlst template("puppet:///modules/orawls/functions/function_base.py.erb", binding), environment
      value.first['value']
    end
  end
end
