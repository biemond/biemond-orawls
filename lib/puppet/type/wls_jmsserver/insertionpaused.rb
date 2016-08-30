newproperty(:insertionpaused) do
  include EasyType

  desc <<-EOD

  EOD
  newvalues(1, 0, :default)

  to_translate_to_resource do | raw_resource|
    raw_resource['insertionpaused']
  end

end
