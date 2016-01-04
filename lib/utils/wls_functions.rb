module Utils
  #
  # This module contains all WLS functions that can be directly called from ruby. These
  # functions must return one value. Because all functions are called within the context of
  # a resource in a domain. All functions must pass the current resource.
  #
  module WlsFunctions

    ##
    #
    # decrypt the specified value. 
    #
    def wls_decrypt_value(value, resource)
      wls_function('wls_decrypt_value', binding)
    end


private

    def wls_function(function_name, caller_binding)
      eval("function_name = '#{function_name}'", caller_binding)  # Add functio name to binding
      environment = { 'action' => 'execute', 'type' => :wls_functions }
      value = wlst template("puppet:///modules/orawls/functions/#{function_name}.py.erb", caller_binding), environment
      value.first[function_name]
    end

  end
end
