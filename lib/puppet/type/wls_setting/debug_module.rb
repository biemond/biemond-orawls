newproperty(:debug_module) do
  include EasyType

  desc 'Toggles retaining of WLST Python scripts'

  newvalues(:true, :false)
  defaultto :false

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
