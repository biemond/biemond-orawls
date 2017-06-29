newproperty(:panicaction) do
  include EasyType
  include EasyType::Validators::Name

  desc 'Exit the server process when the kernel encounters a panic condition'
  newvalues('system-exit', 'no-action')
  
  defaultto 'no-action'
  
  to_translate_to_resource do | raw_resource|
    raw_resource['panicaction']
  end

end
