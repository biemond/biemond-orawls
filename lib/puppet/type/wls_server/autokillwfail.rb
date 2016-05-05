newproperty(:autokillwfail) do
  include EasyType

  desc 'Should the server be killed automatically on failure.'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['autokillwfail']
  end

end
