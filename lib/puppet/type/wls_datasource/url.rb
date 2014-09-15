newproperty(:url) do
  include EasyType

  desc 'The jdbc url'

  to_translate_to_resource do | raw_resource|
    raw_resource['url']
  end

end
