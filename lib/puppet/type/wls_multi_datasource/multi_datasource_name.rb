newparam(:multi_datasource_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The multi atasource name'

end
