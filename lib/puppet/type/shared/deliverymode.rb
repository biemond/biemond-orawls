newproperty(:deliverymode) do
  include EasyType

  desc 'deliverymode of the queue'

  newvalues(:'No-Delivery', :'Persistent', :'Non-Persistent')

  defaultto 'No-Delivery'

  to_translate_to_resource do | raw_resource|
    raw_resource['deliverymode']
  end

end
