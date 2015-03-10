newproperty(:restart_max) do
  include EasyType
  include EasyType::Mungers::Integer

  desc 'The number of times that the Node Manager can restart this server within the interval specified in Restart Interval. '

  to_translate_to_resource do | raw_resource|
    raw_resource['restart_max'].to_i
  end

end
