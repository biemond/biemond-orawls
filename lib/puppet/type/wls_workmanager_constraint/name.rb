newparam(:name) do
  include EasyType

  desc "The workmanager constraint name"

  isnamevar

  to_translate_to_resource do | raw_resource|
    raw_resource['name']
  end

end
