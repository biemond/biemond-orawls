newproperty(:users, :array_matching => :all) do
  include EasyType

  desc 'The users of a group'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['users'].nil?
      raw_resource['users'].split(',')
    end
  end

  def insync?(is)
    if is == :absent
      should.empty?
    else
      is.sort == should.sort
    end
  end

end

def users
  self[:users] ? self[:users].join(',') : ''
end

autorequire(:wls_user) { self[:users].nil? ? '' : self[:users].collect { |u| "#{domain}/#{u}" } }
