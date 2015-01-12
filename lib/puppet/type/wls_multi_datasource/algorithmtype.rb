newproperty(:algorithmtype) do
  include EasyType

  desc 'The algorithm determines the connection request processing for the multi data source'

  to_translate_to_resource do |raw_resource|
    raw_resource['algorithmtype']
  end

end
