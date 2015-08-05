newproperty(:messagelogging) do
  include EasyType
  include EasyType::Mungers::Integer

  desc 'Message logging for JMS'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['messagelogging']
  end

end
