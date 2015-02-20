newproperty(:reconnectdelayincrease) do
  include EasyType

  desc 'The incremental delay time, in seconds, that a messaging bridge instance increases its waiting time between one failed reconnection attempt and the next retry.'

  to_translate_to_resource do | raw_resource|
    raw_resource['reconnectdelayincrease']
  end
end
