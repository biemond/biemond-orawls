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

autorequire(:wls_safagent) { autorequire_when(:wls_safagent, 'SAFAgent') }
autorequire(:wls_server) { autorequire_when(:wls_safagent, 'Server') }
autorequire(:wls_cluster) { autorequire_when(:wls_safagent, 'Cluster') }
autorequire(:wls_jmsserver) { autorequire_when(:wls_safagent, 'JMSServer') }

private

def autorequire_when(type, type_name)
  return_value = []
  targets = self[:target] || []
  targets.each_with_index do |value, index|
    return_value << full_name(value) if self[:targettype][index] == type_name
  end
end

def full_name(name)
  "#{domain}/#{name}"
end
