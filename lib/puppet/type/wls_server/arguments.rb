newproperty(:arguments, :array_matching => :all) do
  include EasyType

  desc 'The server sttart arguments of the server.
    Can be specified as an array or a space separated string'
  #or both...
  #The following should also work
  #arguments => ['arg1 arg2','arg3','arg4 arg5']
  #and be idempotent with 'arg4 arg3 arg1 arg2 arg5' and [arg1,arg4,arg2,'arg3 arg5'] etc

  to_translate_to_resource do | raw_resource|
    return [] if raw_resource['arguments'].nil?
    raw_resource['arguments'].split(/\s/)
  end

  munge do |value|
    if value.is_a?(String)
      value = value.split(/\s/)
    else
      raise Puppet::Error "Invalid server start argument: #{value.inspect}"
    end
  end

  def should
    return nil unless defined?(@should)
    #Return simple array out of possibly nested one.  eg [['bar'],['foo','foobar']] into ['bar','foo','foobar']
    @should.join(' ').split(' ')
  end

  def change_to_s(current, desire)
    message = ''
    unless ((current-desire).inspect) == '[]'
      message << "removing #{(current-desire).inspect} "
    end
    unless ((desire-current).inspect) == '[]'
      message << "adding #{(desire-current).inspect} "
    end
    message
  end

  def insync?(is)
    is = [] if is == :absent or is.nil?
    is.sort == should.sort
  end
end
