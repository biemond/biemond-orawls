newproperty(:virtual_host_names) do
  include EasyType

  desc "virtual host names"

  to_translate_to_resource do | raw_resource|
    raw_resource['virtualhostnames']
  end

end
