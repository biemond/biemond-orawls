newparam(:migratable_target_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The name of this migratable target'
end
