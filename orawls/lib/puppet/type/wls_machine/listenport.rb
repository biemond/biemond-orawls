newproperty(:listenport) do
  include EasyType
  include EasyType::Mungers::Integer

  desc 'The listenport of the machine'
  defaultto 5556

  to_translate_to_resource do | raw_resource|
    raw_resource['listenport'].to_f.to_i
  end

end
