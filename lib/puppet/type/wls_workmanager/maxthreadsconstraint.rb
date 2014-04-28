newproperty(:maxthreadsconstraint) do
  include EasyType

  desc "The max threads constraint name"

  to_translate_to_resource do | raw_resource|
    raw_resource['maxthreadsconstraint']
  end

end