newproperty(:datasources, :array_matching => :all) do
  include EasyType

  desc 'The datasources that are part of the multi datasource'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['datasources'].nil?
      raw_resource['datasources'].split(',')
    end
  end

end

def datasources
  self[:datasources] ? self[:datasources].join(',') : ''
end
