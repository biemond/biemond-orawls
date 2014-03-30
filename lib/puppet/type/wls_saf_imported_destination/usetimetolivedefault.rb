newproperty(:usetimetolivedefault) do
  include EasyType

  desc "use time to live default of this SAF imported destination"

  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['usetimetolivedefault']
  end

end