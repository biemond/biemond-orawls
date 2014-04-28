newparam(:workmanager_constraint_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The workmanager constraint name"


end
