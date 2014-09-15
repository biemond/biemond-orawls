newproperty(:arguments) do
  include EasyType

  desc 'The server arguments of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['arguments']
  end

  def should=(values)
    values = values.flatten.join('\n') if values.is_a?(Array)
    @should = values
  end

  def should
    return nil unless defined?(@should)
    return @should
  end

  def insync?(is)
    is == @should
  end
end
