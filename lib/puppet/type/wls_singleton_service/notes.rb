newproperty(:notes) do
  include EasyType

  desc 'Optional notes to attach to this singleton service for documentation purposes'

  to_translate_to_resource do | raw_resource|
    raw_resource['notes']
  end
end
