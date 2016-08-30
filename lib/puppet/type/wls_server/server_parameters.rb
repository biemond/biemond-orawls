newproperty(:server_parameters) do
  include EasyType

  # Please note that we (mis)use the note field in WebLogic for this.
  desc 'The names of the components the server should be a target of'

  defaultto 'None'

  to_translate_to_resource do | raw_resource|
    raw_resource['server_parameters']
  end

end
