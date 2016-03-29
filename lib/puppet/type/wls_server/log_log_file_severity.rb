newproperty(:log_log_file_severity) do
  include EasyType

  desc <<-EOD
  The minimum severity of log messages going to the standard out. 

  EOD

  to_translate_to_resource do | raw_resource|
    raw_resource['log_log_file_severity']
  end

end
