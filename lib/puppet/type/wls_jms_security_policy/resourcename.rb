newparam(:resourcename) do
  include EasyType

  desc 'The name of the jms resource'

  to_translate_to_resource do | raw_resource |
    raw_resource['resourcename']
  end

end
