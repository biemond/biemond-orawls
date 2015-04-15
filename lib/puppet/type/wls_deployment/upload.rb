newproperty(:upload) do
  include EasyType
  include EasyType::Validators::Name

  desc 'Upload option for deployment.'
  newvalues(1, 0)

  defaultto '1'

  to_translate_to_resource do | raw_resource|
    raw_resource['upload']
  end

end
