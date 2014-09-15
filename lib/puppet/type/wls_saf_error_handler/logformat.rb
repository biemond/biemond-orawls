newproperty(:logformat) do
  include EasyType

  desc 'logformat of the SAF imported destination'

  to_translate_to_resource do | raw_resource|
    raw_resource['logformat']
  end

end
