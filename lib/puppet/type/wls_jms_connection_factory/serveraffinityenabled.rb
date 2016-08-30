newproperty(:serveraffinityenabled) do
  include EasyType

  desc 'Server affinity enabled'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['serveraffinityenabled']
  end

end
