newproperty(:weblogic_home_dir) do
  include EasyType

  desc "The WLS homedir"

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
