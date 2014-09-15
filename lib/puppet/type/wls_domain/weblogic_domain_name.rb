newparam(:weblogic_domain_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'Domain name'

end
