newproperty(:rowprefetchsize) do
  include EasyType

  desc 'The row prefetch siZe of the datasource'

  to_translate_to_resource do | raw_resource|
    raw_resource['rowprefetchsize']
  end

end
