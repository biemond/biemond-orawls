newproperty(:jta_max_transactions) do
  include EasyType

  desc 'The JTA transaction max transactions value'

  to_translate_to_resource do | raw_resource|
    raw_resource['jta_max_transactions']
  end

end
