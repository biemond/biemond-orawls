newproperty(:listenaddress) do
  include EasyType

  desc 'The listenaddress of the server'

  to_translate_to_resource do | raw_resource|
    return '' if raw_resource['listenaddress'].nil?
    raw_resource['listenaddress']
  end

  def insync?(is)
    return true if is == '' and should == ' '
    is == should
  end

end
