newproperty(:extrapropertiesvalues, :array_matching => :all) do
  include EasyType

  desc 'The extra property values'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['extrapropertiesvalues'].nil?
      raw_resource['extrapropertiesvalues'].split(',')
    end
  end

end

def extrapropertiesvalues
  self[:extrapropertiesvalues] ? self[:extrapropertiesvalues].join(',') : ''
end
