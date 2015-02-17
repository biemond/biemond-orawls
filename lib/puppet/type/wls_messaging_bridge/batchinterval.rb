newproperty(:batchinterval) do
  include EasyType

  desc 'The maximum amount of time, in milliseconds, that a messaging bridge instance waits before sending a batch of messages in one transaction, regardless of whether the Batch Size has been reached or not'

  to_translate_to_resource do | raw_resource|
    raw_resource['batchinterval']
  end
end