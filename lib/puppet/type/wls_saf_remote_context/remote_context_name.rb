newparam(:remote_context_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'SAF remote context name'

end
