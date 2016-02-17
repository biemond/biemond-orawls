newparam(:destinationtype) do
  include EasyType

  desc 'The destination type of a jms resource (queue or topic)'

  newvalues(:queue, :topic)

  to_translate_to_resource do | raw_resource |
    raw_resource['destinationtype']
  end

end
