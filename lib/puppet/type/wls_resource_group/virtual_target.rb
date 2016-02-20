newproperty(:virtual_target) do
  include EasyType

  desc 'The virtual target name'

  to_translate_to_resource do | raw_resource|
    raw_resource['virtual_target']
  end

end

autorequire(:wls_virtual_target) { "#{domain}/#{virtual_target}" }
