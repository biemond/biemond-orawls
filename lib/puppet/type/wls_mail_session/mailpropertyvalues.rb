newproperty(:mailpropertyvalues, :array_matching => :all) do
  include EasyType

  desc 'The mail property names'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['mailpropertyvalues'].nil?
      raw_resource['mailpropertyvalues'].split(',')
    end
  end

end

def mailpropertyvalues
  self[:mailpropertyvalues] ? self[:mailpropertyvalues].join(',') : ''
end
