newproperty(:targettype, :array_matching => :all) do
  include EasyType

  desc 'The type of the target'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['targettype'].nil?
      raw_resource['targettype'].split(',')
    end
  end

end

def targettype
  self[:targettype] ? self[:targettype].join(',') : ''
end
