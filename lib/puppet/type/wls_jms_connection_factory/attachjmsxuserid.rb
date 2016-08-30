newproperty(:attachjmsxuserid) do
  include EasyType

  desc 'attachjmsxuserid'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['attachjmsxuserid']
  end

end
