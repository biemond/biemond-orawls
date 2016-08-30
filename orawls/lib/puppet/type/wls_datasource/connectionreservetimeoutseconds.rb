newproperty(:connectionreservetimeoutseconds) do
  include EasyType

  desc 'The number of seconds after which a call to reserve a connection from the connection pool will timeout.'

  defaultto '10'

  to_translate_to_resource do | raw_resource|
    raw_resource['connectionreservetimeoutseconds']
  end

end