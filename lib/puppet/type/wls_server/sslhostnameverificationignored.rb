newproperty(:sslhostnameverificationignored) do
  include EasyType

  desc "The ssl hostname verification ignored enabled on the server"
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['sslhostnameverificationignored']
  end

end