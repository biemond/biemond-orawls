newparam(:topic_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The topic name'

end
