newproperty(:cluster) do
  include EasyType

  desc 'The cluster which contains a given server'

  to_translate_to_resource do | raw_resource|
    return '' if raw_resource['cluster'].nil?
    raw_resource['cluster']
  end

end
