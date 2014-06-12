newproperty(:log_filecount) do
  include EasyType

  desc "The domain log filecount"

  to_translate_to_resource do | raw_resource|
    raw_resource['log_filecount']
  end

end