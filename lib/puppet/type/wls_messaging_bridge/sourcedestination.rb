newproperty(:sourcedestination) do
  include EasyType

  desc 'The source destination from which this messaging bridge instance reads messages.'

  to_translate_to_resource do | raw_resource|
    raw_resource['sourcedestination']
  end

end

autorequire(:wls_jms_bridge_destination) { "#{domain}/#{sourcedestination}" if sourcedestination }
