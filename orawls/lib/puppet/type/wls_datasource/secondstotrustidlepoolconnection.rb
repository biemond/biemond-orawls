newproperty(:secondstotrustidlepoolconnection) do
  include EasyType

  desc 'The number of seconds within a connection use that WebLogic Server trusts that the connection is still viable and will skip the connection test, either before delivering it to an application or during the periodic connection testing process.'

  defaultto '10'

  to_translate_to_resource do | raw_resource|
    raw_resource['secondstotrustidlepoolconnection']
  end

end
