newproperty(:weblogic_password) do
  include EasyType

  desc "TODO: Fill in the description"
  defaultto 'weblogic1'

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end
end
