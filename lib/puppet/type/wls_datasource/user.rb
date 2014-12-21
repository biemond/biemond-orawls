newproperty(:user) do
  include EasyType

  desc 'The datasource user name'

  to_translate_to_resource do | raw_resource|
    raw_resource['user']
  end

end

autorequire(:wls_user) {"#{domain}/#{user}"}
