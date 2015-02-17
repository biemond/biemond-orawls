newproperty(:started) do
  include EasyType

  desc 'Specifies the initial operating state of a targeted messaging bridge instance.'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['started']
  end
end
