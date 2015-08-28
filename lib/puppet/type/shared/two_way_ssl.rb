newproperty(:two_way_ssl) do
  include EasyType

  desc 'Should Two Way SSL be used on the server.'
  newvalues(1, 0)

  to_translate_to_resource do |raw_resource|
    raw_resource['two_way_ssl']
  end

end
