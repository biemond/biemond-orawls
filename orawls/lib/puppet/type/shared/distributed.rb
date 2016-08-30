newproperty(:distributed) do
  include EasyType
  include EasyType::Mungers::Integer

  desc 'Distributed queue'
  newvalues(1, 0)
  defaultto 0

  to_translate_to_resource do | raw_resource|
    raw_resource['distributed']
  end

end
