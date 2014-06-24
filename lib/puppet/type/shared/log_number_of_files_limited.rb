newproperty(:log_number_of_files_limited) do
  include EasyType

  desc "Limited log number of files of a domain or server"

  to_translate_to_resource do | raw_resource|
    raw_resource['log_number_of_files_limited']
  end

end