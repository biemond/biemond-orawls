newparam(:jdbc_persistence_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The JDBC persistence name'

end
