newproperty(:root_file_system) do
  include EasyType

  desc 'The resource domain partition file system'

  to_translate_to_resource do | raw_resource|
    raw_resource['root_file_system']
  end

end
