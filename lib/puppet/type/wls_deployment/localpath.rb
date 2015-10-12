newparam(:localpath) do
  include EasyType

  desc 'The local path of the artifact'
  isnamevar

  validate do |value|
    unless Pathname.new(value).absolute?
      fail("#{value} is not an absolute path")
    end

    if Pathname.new(value).dirname.cleanpath.to_s == '/tmp'
      #Weblogic 12.1.1 deployments will fail it localpath is directly in /tmp
      fail("localpath can not be in /tmp")
    end

  end

end

autorequire(:file) { localpath }
