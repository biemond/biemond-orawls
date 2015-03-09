newproperty(:testfrequency) do
  include EasyType

  desc 'The number of seconds a WebLogic Server instance waits between attempts when testing unused connections. (Requires that you specify a Test Table Name.) Connections that fail the test are closed and reopened to re-establish a valid physical connection.'

  defaultto '120'

  to_translate_to_resource do | raw_resource|
    raw_resource['testfrequency']
  end

end
