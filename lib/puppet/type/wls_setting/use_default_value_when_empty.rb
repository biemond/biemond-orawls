newproperty(:use_default_value_when_empty) do
  include EasyType

  desc 'Use default value when attribute value is not provided'

  newvalues(:true, :false)

  defaultto :true

  to_translate_to_resource do |raw_resource|
    raw_resource[self.name]
  end

end
