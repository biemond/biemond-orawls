newproperty(:usexa) do
  include EasyType
  include EasyType::Validators::Name

  desc 'the UseXaDataSourceInterface enabled on the jdbc driver'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['usexa']
  end

end
