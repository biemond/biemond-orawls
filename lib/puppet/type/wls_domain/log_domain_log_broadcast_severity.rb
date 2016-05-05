newproperty(:log_domain_log_broadcast_severity) do
  include EasyType

  desc <<-EOD
  The minimum severity of log messages going to the domain log from this server's log broadcaster. 

  EOD

  to_translate_to_resource do | raw_resource|
    raw_resource['log_domain_log_broadcast_severity']
  end

end
