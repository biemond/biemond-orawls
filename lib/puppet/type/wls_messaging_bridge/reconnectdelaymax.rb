newproperty(:reconnectdelaymax) do
  include EasyType

  desc 'The longest time, in seconds, that a messaging bridge instance waits between one failed attempt to connect to the source or target, and the next retry.'

  to_translate_to_resource do | raw_resource|
    raw_resource['reconnectdelaymax']
  end
end
