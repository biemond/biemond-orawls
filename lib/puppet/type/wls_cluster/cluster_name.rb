newparam(:cluster_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The cluster name"

end
