newparam(:subdeployment_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The subdeployment name'

end
