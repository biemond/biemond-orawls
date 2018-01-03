newproperty(:log_rotationdir) do
  include EasyType

  desc 'The log rotation dir of the server'

  defaultto ''

  to_translate_to_resource do | raw_resource|
    raw_resource['log_rotationdir']
  end

end
