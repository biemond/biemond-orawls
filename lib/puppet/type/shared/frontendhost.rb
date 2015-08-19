newproperty(:frontendhost) do
  include EasyType

  desc 'The frontendhost of this server'

  to_translate_to_resource do | raw_resource|
    raw_resource['frontendhost']
  end

end
