newproperty(:max_message_size) do
  include EasyType

  desc 'The max message size of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['max_message_size']
  end

end
