newproperty(:defaultdeliverymode) do
  include EasyType

  desc 'The default delivery mode'

  to_translate_to_resource do | raw_resource|
    raw_resource['defaultdeliverymode']
  end

end
