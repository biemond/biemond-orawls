newproperty(:weblogic_user) do
  include EasyType

  desc "the weblogic user account "
  defaultto 'weblogic'

  to_translate_to_resource do | raw_resource|
    raw_resource['weblogic_user']
  end

end
