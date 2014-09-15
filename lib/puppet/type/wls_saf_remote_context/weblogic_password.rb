newparam(:weblogic_password) do
  include EasyType

  desc 'Remote WebLogic password'

  to_translate_to_resource do | raw_resource|
    raw_resource['weblogic_password']
  end
end
