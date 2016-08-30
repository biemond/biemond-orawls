newproperty(:mailproperty, :array_matching => :all) do
  include EasyType

  desc 'The mail properties'

  to_translate_to_resource do | raw_resource|
    unless raw_resource['mailproperty'].nil?
      raw_resource['mailproperty'].split(',')
    end
  end

  def insync?(is)
    is.sort == should.sort
  end

end

def mailproperty
  self[:mailproperty] ? self[:mailproperty].join(',') : ''
end
