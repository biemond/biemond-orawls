newproperty(:target, :array_matching => :all) do
  include EasyType

  desc 'The target name'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['target'].nil?
      raw_resource['target'].split(',')
    end
  end

end

def target
  self[:target] ? self[:target].join(',') : ''
end
