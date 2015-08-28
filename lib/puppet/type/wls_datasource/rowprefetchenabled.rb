newproperty(:rowprefetchenabled) do
  include EasyType
  include EasyType::Validators::Name

  desc 'Enables the data source to prefetch rows.'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['rowprefetchenabled']
  end

end
