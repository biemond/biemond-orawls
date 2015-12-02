newproperty(:consumptionpaused) do
  include EasyType
  include EasyType::Mungers::Integer

  desc <<-EOD

  EOD
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['consumptionpaused']
  end

end
