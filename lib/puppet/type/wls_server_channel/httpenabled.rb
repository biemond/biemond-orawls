newproperty(:httpenabled) do
  include EasyType

  desc 'The channel HTTP enabled on the server'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['httpenabled']
  end

end
