newproperty(:log_rotate_logon_startup) do
  include EasyType

  desc "The domain log rotate Logon startup"

  to_translate_to_resource do | raw_resource|
    raw_resource['log_rotate_logon_startup']
  end

end