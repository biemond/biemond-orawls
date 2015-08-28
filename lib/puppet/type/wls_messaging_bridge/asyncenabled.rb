newproperty(:asyncenabled) do
  include EasyType

  desc 'Specifies if a messaging bridge instance forwards in asynchronous messaging mode'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['asyncenabled']
  end
end
