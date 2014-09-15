newparam(:datasource_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The datasource name'

end
