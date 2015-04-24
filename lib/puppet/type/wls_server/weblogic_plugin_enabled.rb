newproperty(:weblogic_plugin_enabled) do
  include EasyType

  desc 'The Weblogic Plugin Enabled on the server'
  newvalues('1', '0')

  to_translate_to_resource do | raw_resource|
    raw_resource['weblogic_plugin_enabled']
  end

end
