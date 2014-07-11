newproperty(:target, :array_matching => :all) do
  include EasyType

  desc "The target name"

  to_translate_to_resource do | raw_resource|
    raw_resource['target'].split(',')
  end

end

def target
  self[:targettype] ? self[:target].join(',') : ''
end
