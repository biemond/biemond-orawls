newproperty(:control_flag) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The control flag'

  to_translate_to_resource do | raw_resource|
    raw_resource['control_flag']
  end

end
