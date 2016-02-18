newproperty(:inactiveconnectiontimeoutseconds) do
  include EasyType

  desc 'The number of inactive seconds on a reserved connection before WebLogic Server reclaims the connection and releases it back into the connection pool.'

  defaultto '0'

  to_translate_to_resource do | raw_resource|
    raw_resource['inactiveconnectiontimeoutseconds']
  end

end