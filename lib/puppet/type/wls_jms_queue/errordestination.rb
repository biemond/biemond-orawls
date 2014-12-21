newproperty(:errordestination) do
  include EasyType

  desc 'errordestination of the queue'

  to_translate_to_resource do | raw_resource|
    raw_resource['errordestination']
  end

end

autorequire(:wls_jms_queue) { "#{domain}/#{jmsmodule}:#{errordestination}" if errordestination}
