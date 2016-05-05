newproperty(:sort_order) do
  include EasyType

  desc 'The sort order'

  to_translate_to_resource do | raw_resource|
    raw_resource['sort_order']
  end

end
