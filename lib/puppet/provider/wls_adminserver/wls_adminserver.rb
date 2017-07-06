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
    extra_arguments             = resource[:extra_arguments]

    Puppet.debug "adminserver custom trust: #{custom_trust}"

    if "#{custom_trust}" == 'true'
      config = "-Dweblogic.ssl.JSSEEnabled=#{jsse_enabled} -Dweblogic.security.SSL.enableJSSE=#{jsse_enabled} -Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=#{trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=#{trust_keystore_passphrase} #{extra_arguments}"
    else
      config = "-Dweblogic.ssl.JSSEEnabled=#{jsse_enabled} -Dweblogic.security.SSL.enableJSSE=#{jsse_enabled} #{extra_arguments}"
    end

    base_path = weblogic_home_dir

    if action == :start
      wls_action = "nmStart(\"#{name}\")"
    else
      wls_action = "nmKill(\"#{name}\")"
    end

    if "#{nodemanager_secure_listener}" == 'true'
      nm_protocol = 'ssl'
    else
      nm_protocol = 'plain'
    end

    command = "#{base_path}/common/bin/wlst.sh -skipWLSModuleScanning <<-\"EOF\"
nmConnect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"#{nodemanager_address}\",#{nodemanager_port},\"#{domain_name}\",\"#{domain_path}\",\"#{nm_protocol}\")
#{wls_action}
nmDisconnect()
EOF"

    command2 = "#{base_path}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
nmConnect(\"#{weblogic_user}\",\"xxxxx\",\"#{nodemanager_address}\",#{nodemanager_port},\"#{domain_name}\",\"#{domain_path}\",\"#{nm_protocol}\")
#{wls_action}
nmDisconnect()
EOF"

    Puppet.info "adminserver action: #{action} with command #{command2} and CONFIG_JVM_ARGS=#{config}"
    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''
        
    if Puppet.features.root?
      output = `su #{su_shell} - #{user} -c 'export CONFIG_JVM_ARGS="#{config}";#{command}'`
    else
      output = `export CONFIG_JVM_ARGS="#{config}";#{command}`
    end
    
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

    if !output.to_s.empty?
      Puppet.debug 'found server'
      return 'Found'
    else
      Puppet.debug 'server not found'
      return 'NotFound'      
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
