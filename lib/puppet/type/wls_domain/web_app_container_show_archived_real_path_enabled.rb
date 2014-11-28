newparam(:web_app_container_show_archived_real_path_enabled) do
  include EasyType

  desc 'Archived real path enabled'

  to_translate_to_resource do | raw_resource|
    raw_resource['web_app_container_show_archived_real_path_enabled']
  end

end
