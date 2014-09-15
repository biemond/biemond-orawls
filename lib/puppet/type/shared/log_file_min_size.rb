newproperty(:log_file_min_size) do
  include EasyType

  desc 'The log file min size of a domain or server'

  to_translate_to_resource do | raw_resource|
    raw_resource['log_file_min_size']
  end

end
