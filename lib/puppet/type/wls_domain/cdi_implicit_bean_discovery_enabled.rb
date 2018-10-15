newproperty(:cdi_implicit_bean_discovery_enabled) do
  include EasyType

  desc 'CDI implicit bean discovery enabled'

  to_translate_to_resource do |raw_resource|
    raw_resource['cdi_implicit_bean_discovery_enabled']
  end

end