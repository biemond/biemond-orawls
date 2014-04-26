newparam(:machine_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The machine name"

end
