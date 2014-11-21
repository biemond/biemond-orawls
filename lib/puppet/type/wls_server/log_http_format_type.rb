newproperty(:log_http_format_type) do
  include EasyType

  desc 'The log format type of the  http file name of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['log_http_format_type']
  end

end
