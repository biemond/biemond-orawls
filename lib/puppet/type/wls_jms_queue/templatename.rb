newproperty(:templatename) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The template name'

  to_translate_to_resource do |raw_resource|
    raw_resource['templatename']
  end

end
