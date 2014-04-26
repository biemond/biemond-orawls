newparam(:file_persistence_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The file persistence name"

end
