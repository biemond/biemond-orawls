newproperty(:expression) do
  include EasyType

  desc 'The expression used to specify the role'

  to_translate_to_resource do | raw_resource|
    raw_resource['expression']
  end

end
