newproperty(:log_redirect_stdout_to_server) do
  include EasyType

  desc 'When enabled, this redirects the stdout of the JVM in which a WebLogic Server instance runs, to the WebLogic logging system.'

  to_translate_to_resource do | raw_resource|
    raw_resource['log_redirect_stdout_to_server']
  end

end
