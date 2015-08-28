newproperty(:setarchiveconfigurationcount) do
  include EasyType

  desc 'The amount of archived backups of the domain configuration file retained'

  to_translate_to_resource do | raw_resource|
    raw_resource['setarchiveconfigurationcount']
  end

end
