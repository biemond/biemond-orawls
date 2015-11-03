newproperty(:deployment_order) do
  include EasyType

  desc 'The deployment order'

  to_translate_to_resource do | raw_resource|
    raw_resource['deployment_order']
  end

end
