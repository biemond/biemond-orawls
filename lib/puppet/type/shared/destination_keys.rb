newproperty(:destination_keys, :array_matching => :all) do
  include EasyType

  desc 'The destination keys the queue or topic'

  to_translate_to_resource do | raw_resource|
    if raw_resource['destination_keys']
      raw_resource['destination_keys'].split(',')
    end
  end

  # def insync?(is)
  #   is = [] if is == :absent or is.nil?
  # end

end

def destination_keys
  self[:destination_keys] ? self[:destination_keys].join(',') : ''
end
