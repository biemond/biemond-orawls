newproperty(:listenportenabled) do
  include EasyType

  desc 'If the listenport of the server is enabled'

  newvalues('1', '0', '-1')

  to_translate_to_resource do | raw_resource|
    raw_resource['listenportenabled']
  end

end
