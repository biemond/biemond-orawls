newproperty(:sslhostnameverifier) do
  include EasyType

  desc 'The sslhostnameverifier of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['sslhostnameverifier']
  end

end
