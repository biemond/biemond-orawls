newparam(:storage_enabled) do
  include EasyType
  include EasyType::Validators::Name

  desc 'Enables coherence storage on its cluster/server targets'
  newvalues(1, 0)

  defaultto '0'

end
