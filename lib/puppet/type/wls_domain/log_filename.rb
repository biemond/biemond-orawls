newproperty(:log_filename) do
  include EasyType

  desc 'The domain log filename'

  to_translate_to_resource do | raw_resource|
    raw_resource['log_filename']
  end

end
