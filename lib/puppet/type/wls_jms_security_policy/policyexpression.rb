newproperty(:policyexpression) do
  include EasyType

  desc 'A string representation of an security authorization policy'

  to_translate_to_resource do | raw_resource |
    raw_resource['policyexpression']
  end

end
