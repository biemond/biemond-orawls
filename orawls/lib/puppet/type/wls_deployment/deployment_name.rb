newparam(:deployment_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The deployment name'

end
