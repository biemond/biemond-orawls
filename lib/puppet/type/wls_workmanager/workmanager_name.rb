newparam(:workmanager_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The workmanager name"


end
