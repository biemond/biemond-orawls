newproperty(:connectioncreationretryfrequency) do
  include EasyType

  desc 'The number of seconds between attempts to establish connections to the database.'

  defaultto '0'

  to_translate_to_resource do | raw_resource|
    raw_resource['connectioncreationretryfrequency']
  end

end
