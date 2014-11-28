newproperty(:subscriptionsharingpolicy) do
  include EasyType

  desc 'Subscription sharing policy'

  to_translate_to_resource do | raw_resource|
    raw_resource['subscriptionsharingpolicy']
  end

end
