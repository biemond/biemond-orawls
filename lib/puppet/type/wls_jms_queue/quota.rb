newproperty(:quota) do
  include EasyType

  desc "quota of the queue"

  to_translate_to_resource do | raw_resource|
    raw_resource['quota']
  end

end
