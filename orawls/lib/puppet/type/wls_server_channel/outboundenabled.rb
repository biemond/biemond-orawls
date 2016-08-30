newproperty(:outboundenabled) do
  include EasyType

  desc 'The channel outbound enabled on the server'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['outboundenabled']
  end

end
