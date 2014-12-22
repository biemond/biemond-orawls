newproperty(:servers, :array_matching => :all) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The nodes which are part of this cluster'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['servers'].nil?
      raw_resource['servers'].split(',')
    end
  end

end

def servers
  self[:servers] ? self[:servers].join(',') : ''
end

autorequire(:wls_server) { self[:servers].collect { |s| "#{domain}/#{s}" } }
