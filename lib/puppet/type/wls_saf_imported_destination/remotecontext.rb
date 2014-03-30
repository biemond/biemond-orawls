newproperty(:remotecontext) do
  include EasyType

  desc "the SAF Remote Context of this SAF imported destination"

  to_translate_to_resource do | raw_resource|
    raw_resource['remotecontext']
  end

end
