newproperty(:virtual_host_names, :array_matching => :all) do
  include EasyType

  desc "virtual host names"

  to_translate_to_resource do | raw_resource|
    unless raw_resource['virtualhostnames'].nil?
      raw_resource['virtualhostnames'].split(',')
    end
  end

end


def virtual_host_names
  self[:virtual_host_names] ? self[:virtual_host_names].join(',') : ''
end
