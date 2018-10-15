newproperty(:distribution_policy) do
  include EasyType

  desc 'The JDBC persistent store distribution policy'

  to_translate_to_resource do | raw_resource |
    raw_resource['distribution_policy']
  end

end
