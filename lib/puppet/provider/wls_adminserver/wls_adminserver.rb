Puppet::Type.type(:wls_adminserver).provide(:wls_adminserver) do

  def self.instances
    []
  end

  def adminserver_control(action)
    Puppet.debug "adminserver action: #{action}"

    domain_name                 = resource[:domain_name]
    domain_path                 = resource[:domain_path]
    name                        = resource[:server_name]
    user                        = resource[:os_user]
    weblogic_home_dir           = resource[:weblogic_home_dir]
    weblogic_user               = resource[:weblogic_user]
    weblogic_password           = resource[:weblogic_password]
    nodemanager_address         = resource[:nodemanager_address]
    nodemanager_port            = resource[:nodemanager_port]
    nodemanager_secure_listener = resource[:nodemanager_secure_listener]
    jsse_enabled                = resource[:jsse_enabled]
    custom_trust                = resource[:custom_trust]
    trust_keystore_file         = resource[:trust_keystore_file]
    trust_keystore_passphrase   = resource[:trust_keystore_passphrase]
    ohs_standalone_server       = resource[:ohs_standalone_server]

    Puppet.debug "adminserver custom trust: #{custom_trust}"

    if "#{custom_trust}" == 'true'
      config = "-Dweblogic.ssl.JSSEEnabled=#{jsse_enabled} -Dweblogic.security.SSL.enableJSSE=#{jsse_enabled} -Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=#{trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=#{trust_keystore_passphrase}"
    else
      config = "-Dweblogic.ssl.JSSEEnabled=#{jsse_enabled} -Dweblogic.security.SSL.enableJSSE=#{jsse_enabled}"
    end

    if action == :start
      if "#{ohs_standalone_server}" == 'true'
        wls_action = "nmStart(serverName=\"#{name}\", serverType=\"OHS\")"
      else
        wls_action = "nmStart(\"#{name}\")"
      end
    else
      if "#{ohs_standalone_server}" == 'true'
        wls_action = "nmKill(serverName=\"#{name}\", serverType=\"OHS\")"
      else
        wls_action = "nmKill(\"#{name}\")"
      end
    end

    if "#{nodemanager_secure_listener}" == 'true'
      nm_protocol = 'ssl'
    else
      nm_protocol = 'plain'
    end

    command = "#{weblogic_home_dir}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
nmConnect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"#{nodemanager_address}\",#{nodemanager_port},\"#{domain_name}\",\"#{domain_path}\",\"#{nm_protocol}\")
#{wls_action}
nmDisconnect()
EOF"

    command2 = "#{weblogic_home_dir}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
nmConnect(\"#{weblogic_user}\",\"xxxxx\",\"#{nodemanager_address}\",#{nodemanager_port},\"#{domain_name}\",\"#{domain_path}\",\"#{nm_protocol}\")
#{wls_action}
nmDisconnect()
EOF"

    Puppet.info "adminserver action: #{action} with command #{command2} and CONFIG_JVM_ARGS=#{config}"
    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''

    output = `su #{su_shell} - #{user} -c 'export CONFIG_JVM_ARGS="#{config}";#{command}'`
    Puppet.info "adminserver result: #{output}"
  end

  def adminserver_status
    domain_name    = resource[:domain_name]
    name           = resource[:server_name]

    kernel = Facter.value(:kernel)

    ps_bin = (kernel != 'SunOS' || (kernel == 'SunOS' && Facter.value(:kernelrelease) == '5.11')) ? '/bin/ps' : '/usr/ucb/ps'
    ps_arg = kernel == 'SunOS' ? 'awwx' : '-ef'

    command  = "#{ps_bin} #{ps_arg} | /bin/grep -v grep | /bin/grep 'weblogic.Name=#{name}' | /bin/grep #{domain_name}"

    Puppet.debug "adminserver_status #{command}"
    output = `#{command}`

    output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}"
        if li.include? name
          Puppet.debug 'found server'
          return 'Found'
        end
      end
    end
    'NotFound'
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
    if output == 'Found'
      return :start
    else
      return :stop
    end
  end
end
