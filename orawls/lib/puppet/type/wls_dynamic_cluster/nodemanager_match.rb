newproperty(:nodemanager_match) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The nodemanager match of this dynamic cluster'

  to_translate_to_resource do | raw_resource|
    raw_resource['nodemanager_match']
  end

end
