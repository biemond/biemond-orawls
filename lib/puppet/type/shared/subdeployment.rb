newproperty(:subdeployment) do
  include EasyType

  desc 'The subdeployment name'

  to_translate_to_resource do | raw_resource|
    raw_resource['subdeployment']
  end

end

autorequire(:wls_subdeployment) { subdeployment}