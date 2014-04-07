newproperty(:object_type) do
  include EasyType

  desc "The object_type of a Foreign Server object "

  newvalues(:destination, :connectionfactory)

  to_translate_to_resource do | raw_resource|
    raw_resource['object_type']
  end

end
