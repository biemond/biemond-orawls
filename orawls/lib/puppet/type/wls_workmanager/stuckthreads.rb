newproperty(:stuckthreads) do
  include EasyType

  desc 'The stuckthreads of a workmanager'
  newvalues('1', '0')

  to_translate_to_resource do | raw_resource|
    raw_resource['stuckthreads']
  end

end
