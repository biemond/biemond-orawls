newproperty(:transactiontimeout) do
  include EasyType

  desc "transaction timeout on the cf"

  to_translate_to_resource do | raw_resource|
    raw_resource['transactiontimeout']
  end

end
