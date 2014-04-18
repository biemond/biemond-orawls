newproperty(:tunnelingenabled) do
  include EasyType

  desc "The channel tunneling enabled on the server"
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['tunnelingenabled']
  end

end
