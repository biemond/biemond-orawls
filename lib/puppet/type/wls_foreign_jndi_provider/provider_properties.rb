newproperty(:provider_properties, :array_matching => :all) do
  include EasyType

  desc 'The properties for the Foreign JNDI provider'

  def insync?(is)
    if is.kind_of?(Array)
      is.sort == should.sort
    end
  end

  to_translate_to_resource do | raw_resource|
    unless raw_resource['provider_properties'].nil?
      Hash[raw_resource['provider_properties'].scan(/(\w+)=(\w+)/)].collect{|k,v| "#{k}=#{v}"}
    end
  end

end

def provider_properties
  self[:provider_properties] ? self[:provider_properties].join(',') : ''
end
