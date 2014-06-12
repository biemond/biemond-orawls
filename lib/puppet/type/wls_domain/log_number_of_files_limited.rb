newproperty(:log_number_of_files_limited) do
  include EasyType

  desc "The domain log number of files limited"

  to_translate_to_resource do | raw_resource|
    raw_resource['log_number_of_files_limited']
  end

end