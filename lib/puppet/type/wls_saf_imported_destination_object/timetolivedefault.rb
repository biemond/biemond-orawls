newproperty(:timetolivedefault) do
  include EasyType

  desc "the SAF time to live default of this SAF imported destination"

  to_translate_to_resource do | raw_resource|
    raw_resource['timetolivedefault']
  end

end