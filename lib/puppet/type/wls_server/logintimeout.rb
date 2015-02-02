newproperty(:logintimeout) do
  include EasyType
  include EasyType::Mungers::Integer

  desc 'The HTTP Login Timeout of the server in milliseconds'

  to_translate_to_resource do | raw_resource|
    raw_resource['logintimeout'].to_f.to_i
  end

end
