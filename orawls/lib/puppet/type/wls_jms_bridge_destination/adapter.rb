newproperty(:adapter) do
  include EasyType

  desc 'The JNDI name of the adapter used to communicate with the specified destination.'

  newvalues('eis.jms.WLSConnectionFactoryJNDINoTX', 'eis.jms.WLSConnectionFactoryJNDIXA')
  defaultto 'eis.jms.WLSConnectionFactoryJNDINoTX'

  to_translate_to_resource do | raw_resource|
    raw_resource['adapter']
  end

end
