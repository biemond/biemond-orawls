newproperty(:batchsize) do
  include EasyType

  desc 'The number of messages that are processed within one transaction.'

  to_translate_to_resource do | raw_resource|
    raw_resource['batchsize']
  end
end
