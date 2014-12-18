newproperty(:quota) do
  include EasyType

  desc 'quota of the jms object'

  to_translate_to_resource do | raw_resource|
    raw_resource['quota']
  end

end

autorequire(:wls_quota) { quota }
