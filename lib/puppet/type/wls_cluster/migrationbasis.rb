newproperty(:migrationbasis) do
  include EasyType
  include EasyType::Validators::Name

  desc "The migrationbasis of this cluster"

  defaultto 'consensus'


  to_translate_to_resource do | raw_resource|
    raw_resource['migrationbasis']
  end

end
