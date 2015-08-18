newproperty(:frontendhttpsport) do
  include EasyType

  desc 'The frontendhttpsport of this server'
  defaultto '0'

  to_translate_to_resource do | raw_resource|
    raw_resource['frontendhttpsport']
  end

end
