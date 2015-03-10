newproperty(:log_http_file_count) do
  include EasyType

  desc 'The log http file name of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['log_http_file_count']
  end

end
