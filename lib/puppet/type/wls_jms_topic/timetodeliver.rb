newproperty(:timetodeliver) do
  include EasyType
  include EasyType::Mungers::Integer

  defaultto(-1)

  desc 'timetodeliver of the topic'

  to_translate_to_resource do | raw_resource|
    raw_resource['timetodeliver'].to_f.to_i
  end

end
