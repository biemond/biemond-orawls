newproperty(:clientidpolicy) do
  include EasyType

  desc 'clientidpolicy'

  to_translate_to_resource do | raw_resource|
    raw_resource['clientidpolicy']
  end

end
