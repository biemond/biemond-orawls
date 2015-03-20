newproperty(:forwarddelay) do
  include EasyType
  include EasyType::Mungers::Integer

  defaultto(-1)

  desc 'The number of seconds after which a uniform distributed queue member with no consumers will wait before forwarding its messages to other uniform distributed queue members that do have consumers. '

  to_translate_to_resource do | raw_resource|
    raw_resource['forwarddelay'].to_f.to_i
  end

end
