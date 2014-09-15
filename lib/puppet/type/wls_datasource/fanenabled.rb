newproperty(:fanenabled) do
  include EasyType
  include EasyType::Validators::Name

  desc "Enables the data source to subscribe to and process Oracle FAN events."
  newvalues(1, 0)

  defaultto '0'

  to_translate_to_resource do | raw_resource|
    raw_resource['fanenabled']
  end

end