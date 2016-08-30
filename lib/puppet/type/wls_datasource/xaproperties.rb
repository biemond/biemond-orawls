newproperty(:xaproperties, :array_matching => :all) do
  include EasyType

  desc 'Datasource XA properties'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['xaproperties'].nil?
      raw_resource['xaproperties'].split(',')
    end
  end

  def insync?(is)
    if is.kind_of?(Array)
      is.sort == should.sort
    end
  end

end

def xaproperties
  self[:xaproperties] ? self[:xaproperties].join(',') : ''
end
