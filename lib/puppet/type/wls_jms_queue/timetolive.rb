newproperty(:timetolive) do
  include EasyType
  include EasyType::Mungers::Integer

  defaultto -1

  desc 'timetolive of the queue'

  to_translate_to_resource do | raw_resource|
    raw_resource['timetolive'].to_f.to_i
  end

end
