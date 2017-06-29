newproperty(:failureaction) do
  include EasyType
  include EasyType::Validators::Name

  desc 'Enable automatic forceshutdown of the server on failed state'
  newvalues('force-shutdown', 'admin-state','no-action')
  
  defaultto 'no-action'
  
  to_translate_to_resource do | raw_resource|
    raw_resource['failureaction']
  end

end
