newproperty(:removeinfectedconnections, :boolean => true) do
  include EasyType

  desc 'Specifies whether a connection will be removed from the connection pool after the application uses the underlying vendor connection object.'

  newvalues(:true, :false, '0', '1')

  munge do |value|
    case value
    when true, "true", :true, '1', "True", True
      :true
    when false, "false", :false, '0', "False", False
      :false
    else
      fail("#{value} must be a boolean")
    end
  end

  to_translate_to_resource do |raw_resource|
    return :true  if raw_resource['removeinfectedconnections'] == '1'
    return :false if raw_resource['removeinfectedconnections'] == '0'
    return :true  if raw_resource['removeinfectedconnections'] == 'True'
    return :false if raw_resource['removeinfectedconnections'] == 'False'
    fail('BUG! removeinfectedconnections should have been \'0\' or \'1\'')
  end

end
