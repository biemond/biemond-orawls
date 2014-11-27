newproperty(:messagesmaximum) do
  include EasyType
  include EasyType::Validators::Integer

  desc 'Maximum messages'

  to_translate_to_resource do | raw_resource|
    raw_resource['messagesmaximum']
  end

end
