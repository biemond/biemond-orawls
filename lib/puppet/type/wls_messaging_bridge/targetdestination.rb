newproperty(:targetdestination) do
  include EasyType

  desc 'The target destination where a messaging bridge instance sends the messages it receives from the source destination.'

  to_translate_to_resource do | raw_resource|
    raw_resource['targetdestination']
  end

end

autorequire(:wls_jms_bridge_destination) { "#{domain}/#{targetdestination}" if targetdestination }
