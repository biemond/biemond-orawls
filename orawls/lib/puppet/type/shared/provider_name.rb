newparam(:provider_name) do
  include EasyType

  isnamevar

  desc 'The provider name'

end

#autorequire(:wls_foreign_jndi_provider) { "#{domain}/#{provider_name}" }
