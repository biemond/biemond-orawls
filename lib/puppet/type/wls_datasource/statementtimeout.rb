newproperty(:statementtimeout) do
  include EasyType

  desc 'Statement timeout'

  to_translate_to_resource do | raw_resource|
    raw_resource['statementtimeout']
  end

end