newproperty(:clientid) do
  include EasyType

  desc 'clientid'

  to_translate_to_resource do | raw_resource|
    raw_resource['clientid']
  end

end
