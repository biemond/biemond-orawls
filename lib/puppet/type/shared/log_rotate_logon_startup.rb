newproperty(:log_rotate_logon_startup) do
  include EasyType

  desc "log rotate Logon at startup of a domain or server"

  to_translate_to_resource do | raw_resource|
    raw_resource['log_rotate_logon_startup']
  end

end