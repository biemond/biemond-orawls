newproperty(:log_http_format) do
  include EasyType

  desc 'The log http format of the file name of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['log_http_format']
  end

end
