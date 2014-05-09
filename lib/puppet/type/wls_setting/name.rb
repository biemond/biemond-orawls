newparam(:name) do
  include EasyType

  desc "The name of the setting"

  isnamevar

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
