newproperty(:drivername) do
  include EasyType

  desc 'The drivername'

  to_translate_to_resource do |raw_resource|
    raw_resource['drivername']
  end

end
