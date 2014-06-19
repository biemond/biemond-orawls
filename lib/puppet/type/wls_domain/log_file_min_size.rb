newproperty(:log_file_min_size) do
  include EasyType

  desc "The domain log file min size"

  to_translate_to_resource do | raw_resource|
    raw_resource['log_file_min_size']
  end

end