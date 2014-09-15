newproperty(:client_certificate_enforced) do
  include EasyType

  desc 'Should client certificate be enforced on the server.'
  newvalues(1, 0)

  defaultto '0'

  to_translate_to_resource do | raw_resource|
    raw_resource['client_certificate_enforced']
  end

end
