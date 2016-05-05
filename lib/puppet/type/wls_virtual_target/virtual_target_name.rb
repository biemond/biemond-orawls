newparam(:virtual_target_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The virtual target name'

end
