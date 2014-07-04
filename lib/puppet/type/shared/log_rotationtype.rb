newproperty(:log_rotationtype) do
  include EasyType

  desc "log rotation type of a domain or server"

  to_translate_to_resource do | raw_resource|
    raw_resource['log_rotationtype']
  end

end