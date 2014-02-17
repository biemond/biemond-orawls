newproperty(:logfilename) do
  include EasyType

  desc "The log file name of the server"
  
  to_translate_to_resource do | raw_resource|
    raw_resource['logfilename']
  end

end
