newproperty(:initial_context_factory) do
  include EasyType

  desc 'The initial context factory'

  to_translate_to_resource do | raw_resource|
    raw_resource['initial_context_factory']
  end

end
