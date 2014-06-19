newproperty(:log_rotationtype) do
  include EasyType

  desc "The domain log rotation type"

  to_translate_to_resource do | raw_resource|
    raw_resource['log_rotationtype']
  end

end