newproperty(:datasource) do
  include EasyType

  desc 'The JDBC persistent store datasource'

  to_translate_to_resource do | raw_resource |
    raw_resource['datasource']
  end

end

autorequire(:wls_datasource) { datasource }
