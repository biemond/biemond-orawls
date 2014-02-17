newproperty(:user) do
  include EasyType

  desc "Operating System user"
  defaultto 'oracle'

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
