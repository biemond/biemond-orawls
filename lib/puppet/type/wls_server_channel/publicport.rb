newproperty(:publicport) do
  include EasyType

  desc 'The channel public listen port of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['publicport']
  end

end
