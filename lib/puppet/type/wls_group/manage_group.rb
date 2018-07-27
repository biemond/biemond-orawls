newparam(:manage_group) do
  include EasyType
  include EasyType::Validators::Name

  desc 'Modify Current Group Members'
  defaultto 'true'

  newvalues('true', 'false')

  to_translate_to_resource do | raw_resource|
    raw_resource['manage_group']
  end

end
