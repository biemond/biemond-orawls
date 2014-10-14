newproperty(:log_datasource_filename) do
  include EasyType

  desc 'The datasource log file name of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['log_datasource_filename']
  end

end
