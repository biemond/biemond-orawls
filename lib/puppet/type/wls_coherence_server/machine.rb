newproperty(:machine) do
  include EasyType

  desc 'The machine of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['machine']
  end

end

autorequire(:wls_machine) { "#{domain}/#{machine}" }
