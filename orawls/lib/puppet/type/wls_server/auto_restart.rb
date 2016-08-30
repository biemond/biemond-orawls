newproperty(:auto_restart) do
  include EasyType

  desc 'Should the server be restarted automatically.'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['auto_restart']
  end

end
