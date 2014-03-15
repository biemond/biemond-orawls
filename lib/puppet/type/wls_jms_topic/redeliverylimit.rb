newproperty(:redeliverylimit) do
  include EasyType
  include EasyType::Mungers::Integer

  defaultto -1

  desc "redeliverylimit of the topic"

  to_translate_to_resource do | raw_resource|
    raw_resource['redeliverylimit'].to_f.to_i
  end

end
