newproperty(:jndinames, :array_matching => :all) do
  include EasyType

  desc "The datasource jndi names"

  to_translate_to_resource do | raw_resource|
    unless raw_resource['jndinames'].nil?
      raw_resource['jndinames'].split(',')
    end
  end

end


def jndinames
  self[:jndinames] ? self[:jndinames].join(',') : ''
end