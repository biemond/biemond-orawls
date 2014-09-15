newproperty(:errorhandling) do
  include EasyType

  desc 'the SAF Error Handling of this SAF imported destination'

  to_translate_to_resource do | raw_resource|
    raw_resource['errorhandling']
  end

end
