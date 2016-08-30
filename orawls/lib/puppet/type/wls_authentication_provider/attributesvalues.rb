newparam(:attributesvalues) do
  include EasyType

  desc 'The extra authentication provider property values'

  validate do | value|
    Puppet.deprecation_warning("The attributesvalues parameter on wls_authentication_provider is deprecated. Use the provider_specific property now.")
    value
  end

end
