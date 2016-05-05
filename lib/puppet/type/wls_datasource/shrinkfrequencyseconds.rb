newproperty(:shrinkfrequencyseconds) do
  include EasyType

  desc 'Shrink Frequency Seconds'

  to_translate_to_resource do | raw_resource|
    raw_resource['shrinkfrequencyseconds']
  end

end
