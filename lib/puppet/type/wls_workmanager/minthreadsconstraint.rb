newproperty(:minthreadsconstraint) do
  include EasyType

  desc 'The min threads constraint name'

  to_translate_to_resource do | raw_resource|
    raw_resource['minthreadsconstraint']
  end

end
