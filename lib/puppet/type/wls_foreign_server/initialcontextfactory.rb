newproperty(:initialcontextfactory) do
  include EasyType

  desc "The initial contextfactory"

  to_translate_to_resource do | raw_resource|
    raw_resource['initialcontextfactory']
  end

end