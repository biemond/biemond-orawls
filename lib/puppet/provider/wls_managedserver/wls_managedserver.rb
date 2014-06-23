Puppet::Type.type(:wls_managedserver).provide(:wls_managedserver) do

  def self.instances
    []
  end

  def managedserver_control(action)

    Puppet.debug "managedserver action: #{action}"

    target                    = resource[:target]
    name                      = resource[:server_name]
    user                      = resource[:os_user]
    weblogic_home_dir         = resource[:weblogic_home_dir]
    weblogic_user             = resource[:weblogic_user]
    weblogic_password         = resource[:weblogic_password]
    jdk_home_dir              = resource[:jdk_home_dir]
    adminserver_address       = resource[:adminserver_address]
    adminserver_port          = resource[:adminserver_port]

    if action == :start
      wls_action = "start(\"#{name}\",\"#{target}\")"
    else
      wls_action = "shutdown(\"#{name}\",\"#{target}\",\"force=true\")"
    end 

    command = "#{weblogic_home_dir}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
connect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"t3://#{adminserver_address}:#{adminserver_port}\")
#{wls_action}
exit() 
EOF"

    Puppet.debug "managedserver action: #{action} with command #{command}"

    output = `su - #{user} -c '#{command}'`
    Puppet.debug "managedserver result: #{output}"

  end

  def managedserver_status

    domain_name    = resource[:domain_name]
    name           = resource[:server_name]

    if :kernel == 'SunOS'
      command  = "/usr/ucb/ps wwxa | grep -v grep | /bin/grep 'weblogic.Name=#{name}' | /bin/grep #{domain_name}"
    else
      command  = "/bin/ps -ef | grep -v grep | /bin/grep 'weblogic.Name=#{name}' | /bin/grep #{domain_name}"
    end

    Puppet.debug "managedserver_status #{command}"
    output = `#{command}`

    output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}" 
        if li.include? name
          Puppet.debug "found server"
          return "Found"
        end
      end 
    end
    return "NotFound"
  end

  def start
    managedserver_control :start
  end

  def stop
    managedserver_control :stop
  end

  def restart
    managedserver_control :stop
    managedserver_control :start
  end

  def status
    output  = managedserver_status
    Puppet.debug "managedserver_status output #{output}"
    if output == "Found"
      return :start
    else
      return :stop
    end
  end
end