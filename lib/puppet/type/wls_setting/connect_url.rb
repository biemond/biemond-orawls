newproperty(:connect_url) do
  include EasyType

  desc "The url to connect to"
  defaultto 't3://localhost:7001'

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
