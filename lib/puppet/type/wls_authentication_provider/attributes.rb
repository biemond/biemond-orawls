newparam(:attributes) do
  include EasyType

  desc 'The extra authentication provider properties'

  validate do | value|
    Puppet.deprecation_warning("The attributes parameter on wls_authentication_provide is deprecated. Use the provider_specific property now.")
    value
  end

end
