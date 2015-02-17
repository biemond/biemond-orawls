newproperty(:destinationtype) do
  include EasyType

  desc 'The destination type (queue or topic) for this JMS bridge destination.'

  newvalues('Queue', 'Topic')
  defaultto 'Queue'

  to_translate_to_resource do |raw_resource|
    raw_resource['destinationtype']
  end

end
