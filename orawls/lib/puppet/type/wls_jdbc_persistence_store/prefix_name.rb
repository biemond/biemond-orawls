newproperty(:prefix_name) do
  include EasyType

  desc 'The JDBC persistent store prefix name'

  to_translate_to_resource do | raw_resource |
    raw_resource['prefix_name']
  end

end
