newproperty(:virtual_target, :array_matching => :all) do
  include EasyType

  desc 'The virtual target names'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['virtual_target'].nil?
      raw_resource['virtual_target'].split(',')
    end
  end

  def insync?(is)
    is = [] if is == :absent or is.nil?
    is.sort == should.sort
  end

end

autorequire(:wls_virtual_target) { "#{domain}/#{virtual_target}" }

def virtual_target
  self[:virtual_target] ? self[:virtual_target].join(',') : ''
end
