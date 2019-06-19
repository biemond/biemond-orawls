newproperty(:failure_action) do
  include EasyType

  desc 'Failure action. '

  to_translate_to_resource do | raw_resource|
    raw_resource['failure_action']
  end

end
