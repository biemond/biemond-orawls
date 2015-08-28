newproperty(:user_preferred_server) do
  include EasyType

  desc 'The preferred server to run this singleton service on'

  to_translate_to_resource do | raw_resource|
    raw_resource['user_preferred_server']
  end
end
