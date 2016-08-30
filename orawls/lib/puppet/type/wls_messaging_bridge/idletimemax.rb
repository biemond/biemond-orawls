newproperty(:idletimemax) do
  include EasyType

  desc 'The maximum amount of time, in seconds, that a messaging bridge instance remains idle.'

  to_translate_to_resource do | raw_resource|
    raw_resource['idletimemax']
  end
end
