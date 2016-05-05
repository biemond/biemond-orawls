newproperty(:stagingmode) do
  include EasyType

  desc 'The staging type'

  to_translate_to_resource do | raw_resource|
    raw_resource['stagingmode']
  end

end
