newproperty(:selector) do
  include EasyType

  isnamevar

  desc 'The filter for messages that are sent across the messaging bridge instance.'
  
  to_translate_to_resource do |raw_resource|
    raw_resource['selector']
  end

end