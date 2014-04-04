newproperty(:unitoforderrouting) do
  include EasyType

  desc "The unit of order routing of the SAF imported destination object "

  newvalues(:Hash, :PathService)

  to_translate_to_resource do | raw_resource|
    raw_resource['unitoforderrouting']
  end

end
