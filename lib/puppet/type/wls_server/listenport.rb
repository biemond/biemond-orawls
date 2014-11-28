newproperty(:listenport) do
  include EasyType
  include EasyType::Mungers::Integer

  desc 'The listenport of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['listenport'].to_f.to_i
  end

end
