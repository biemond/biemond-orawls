newproperty(:testfrequency) do
  include EasyType

  desc 'The number of seconds a WebLogic Server instance waits between attempts when testing unused connections. '

  to_translate_to_resource do |raw_resource|
    raw_resource['testfrequency']
  end

end
