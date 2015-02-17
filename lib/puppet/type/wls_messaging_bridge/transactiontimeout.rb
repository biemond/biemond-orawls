newproperty(:transactiontimeout) do
  include EasyType

  desc 'The amount of time, in seconds, that the transaction manager waits for each transaction before timing it out.'

  to_translate_to_resource do | raw_resource|
    raw_resource['transactiontimeout']
  end
end