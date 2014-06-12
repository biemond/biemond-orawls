newproperty(:jta_transaction_timeout) do
  include EasyType

  desc "The JTA transaction timeout value"

  to_translate_to_resource do | raw_resource|
    raw_resource['jta_transaction_timeout']
  end

end