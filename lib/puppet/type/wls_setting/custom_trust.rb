newproperty(:custom_trust) do
  include EasyType

  desc 'The custom trust enabled'

  newvalues(:true, :false)

  defaultto :false

  to_translate_to_resource do |raw_resource|
    raw_resource[self.name]
  end

end
