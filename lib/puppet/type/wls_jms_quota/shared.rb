newproperty(:shared) do
  include EasyType
  include EasyType::Validators::Name

  desc 'Shared Quota'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['shared']
  end

end
