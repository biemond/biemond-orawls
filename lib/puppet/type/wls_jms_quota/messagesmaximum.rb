newproperty(:messagesmaximum) do
  include EasyType

  desc 'Maximum messages'

  to_translate_to_resource do | raw_resource|
    raw_resource['messagesmaximum']
  end

end
