newproperty(:order) do
  include EasyType

  desc 'The order of the Authentication Provider (0 is highest)'

  to_translate_to_resource do | raw_resource|
    raw_resource['order']
  end

end
