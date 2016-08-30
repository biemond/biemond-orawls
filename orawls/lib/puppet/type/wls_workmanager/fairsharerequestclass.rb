newproperty(:fairsharerequestclass) do
  include EasyType

  desc 'The fairshare request class name'

  to_translate_to_resource do | raw_resource|
    raw_resource['fairsharerequestclass']
  end

end
