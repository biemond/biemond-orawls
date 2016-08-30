newproperty(:default_file_store) do
  include EasyType

  desc 'The path name to the file system directory where the file store maintains its data files.'

  to_translate_to_resource do | raw_resource|
    raw_resource['default_file_store']
  end

end
