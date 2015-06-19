newproperty(:classpath) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The coherence machine classpath'

  to_translate_to_resource do | raw_resource|
    raw_resource['classpath']
  end

end
