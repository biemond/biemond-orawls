Puppet::Type.type(:wls_adminserver).provide(:wls_adminserver) do

  def self.instances
    []
  end

  def adminserver_control(action)

    Puppet.debug "adminserver action: #{action}"

    domain_name               = resource[:domain_name]
    domain_path               = resource[:domain_path]
    name                      = resource[:server_name]
    user                      = resource[:os_user]
    weblogic_home_dir         = resource[:weblogic_home_dir]
    weblogic_user             = resource[:weblogic_user]
    weblogic_password         = resource[:weblogic_password]
    jdk_home_dir              = resource[:jdk_home_dir]
    nodemanager_address       = resource[:nodemanager_address]
    nodemanager_port          = resource[:nodemanager_port]
    jsse_enabled              = resource[:jsse_enabled]
    custom_trust              = resource[:custom_trust]
    trust_keystore_file       = resource[:trust_keystore_file]
    trust_keystore_passphrase = resource[:trust_keystore_passphrase]

    if custom_trust == true
      config = "-Dweblogic.ssl.JSSEEnabled=#{jsse_enabled} -Dweblogic.security.SSL.enableJSSE=#{jsse_enabled} -Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=#{trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=#{trust_keystore_passphrase}"
    else
      config = "-Dweblogic.ssl.JSSEEnabled=#{jsse_enabled} -Dweblogic.security.SSL.enableJSSE=#{jsse_enabled}"
    end

    if action == :start
      wls_action = "nmStart(\"#{name}\")"
    else
      wls_action = "nmKill(\"#{name}\")"
    end 

    command = "#{weblogic_home_dir}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
nmConnect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"#{nodemanager_address}\",#{nodemanager_port},\"#{domain_name}\",\"#{domain_path}\",\"ssl\")
#{wls_action}
nmDisconnect() 
EOF"

    Puppet.debug "adminserver action: #{action} with command #{command} and CONFIG_JVM_ARGS=#{config}"

    output = `su - #{user} -c 'export CONFIG_JVM_ARGS="#{config}";#{command}'`
    Puppet.debug "adminserver result: #{output}"

  end

  def adminserver_status

    domain_name    = resource[:domain_name]
    name           = resource[:server_name]

    if :kernel == 'SunOS'
      command  = "/usr/ucb/ps wwxa | grep -v grep | /bin/grep 'weblogic.Name=#{name}' | /bin/grep #{domain_name}"
    else
      command  = "/bin/ps -ef | grep -v grep | /bin/grep 'weblogic.Name=#{name}' | /bin/grep #{domain_name}"
    end

    Puppet.debug "adminserver_status #{command}"
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
    adminserver_control :start
  end

  def stop
    adminserver_control :stop
  end

  def restart
    adminserver_control :stop
    adminserver_control :start
  end

  def status
    output  = adminserver_status
    Puppet.debug "adminserver_status output #{output}"
    if output == "Found"
      return :start
    else
      return :stop
    end
  end
end