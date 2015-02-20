newproperty(:defaultmappertype) do
  include EasyType

  desc 'the default mapper type'

  to_translate_to_resource do | raw_resource|
    raw_resource['defaultmappertype']
  end

end
