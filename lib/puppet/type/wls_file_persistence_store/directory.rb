newproperty(:directory) do
  include EasyType

  desc 'The file persistent store directory name'

  to_translate_to_resource do | raw_resource|
    raw_resource['directory']
  end

end
