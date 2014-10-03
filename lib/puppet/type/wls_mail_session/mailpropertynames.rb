newproperty(:mailpropertynames, :array_matching => :all) do
  include EasyType

  desc 'The mail property names'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['mailpropertynames'].nil?
      raw_resource['mailpropertynames'].split(',')
    end
  end

end

def mailpropertynames
  self[:mailpropertynames] ? self[:mailpropertynames].join(',') : ''
end
