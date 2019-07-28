newproperty(:defaultunitoforder) do
  include EasyType

  desc 'The default unit of order'

  to_translate_to_resource do | raw_resource|
    raw_resource['defaultunitoforder']
  end

end
