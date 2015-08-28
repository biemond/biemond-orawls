newproperty(:reconnectdelaymin) do
  include EasyType

  desc 'The minimum amount of time, in seconds, that a messaging bridge instance waits before it tries to reconnect to the source or target destination after a failure.'

  to_translate_to_resource do | raw_resource|
    raw_resource['reconnectdelaymin']
  end
end
