Puppet::Type.type(:wls_ohsserver).provide(:wls_ohsserver) do

  def self.instances
    []
  end

  def ohsserver_control(action)
    Puppet.debug "ohs server action: #{action}"

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

    Puppet.debug "ohs server custom trust: #{custom_trust}"

    if "#{custom_trust}" == 'true'
      config = "-Dweblogic.ssl.JSSEEnabled=#{jsse_enabled} -Dweblogic.security.SSL.enableJSSE=#{jsse_enabled} -Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=#{trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=#{trust_keystore_passphrase} #{extra_arguments}"
    else
      config = "-Dweblogic.ssl.JSSEEnabled=#{jsse_enabled} -Dweblogic.security.SSL.enableJSSE=#{jsse_enabled} #{extra_arguments}"
    end

    base_path = "#{weblogic_home_dir}/../oracle_common"

    if action == :start
      wls_action = "nmStart(serverName=\"#{name}\", serverType=\"OHS\")"
    else
      wls_action = "nmKill(serverName=\"#{name}\", serverType=\"OHS\")"
    end

    if "#{nodemanager_secure_listener}" == 'true'
      nm_protocol = 'ssl'
    else
      nm_protocol = 'plain'
    end

    command = "#{base_path}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
nmConnect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"#{nodemanager_address}\",#{nodemanager_port},\"#{domain_name}\",\"#{domain_path}\",\"#{nm_protocol}\")
#{wls_action}
nmDisconnect()
EOF"

    command2 = "#{base_path}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
nmConnect(\"#{weblogic_user}\",\"xxxxx\",\"#{nodemanager_address}\",#{nodemanager_port},\"#{domain_name}\",\"#{domain_path}\",\"#{nm_protocol}\")
#{wls_action}
nmDisconnect()
EOF"

    Puppet.info "ohs server action: #{action} with command #{command2} and CONFIG_JVM_ARGS=#{config}"
    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''

    if Puppet.features.root?
      output = `su #{su_shell} - #{user} -c 'export CONFIG_JVM_ARGS="#{config}";#{command}'`
    else
      output = `export CONFIG_JVM_ARGS="#{config}";#{command}`
    end

    Puppet.info "ohs server result: #{output}"
  end

  def ohsserver_status
    domain_name                 = resource[:domain_name]
    name                        = resource[:server_name]
    user                        = resource[:os_user]
    domain_path                 = resource[:domain_path]
    nodemanager_address         = resource[:nodemanager_address]
    nodemanager_port            = resource[:nodemanager_port]
    nodemanager_secure_listener = resource[:nodemanager_secure_listener]
    weblogic_home_dir           = resource[:weblogic_home_dir]
    weblogic_user               = resource[:weblogic_user]
    weblogic_password           = resource[:weblogic_password]

    base_path = "#{weblogic_home_dir}/../oracle_common"

    if "#{nodemanager_secure_listener}" == 'true'
      nm_protocol = 'ssl'
    else
      nm_protocol = 'plain'
    end

    kernel = Facter.value(:kernel)

    ps_bin = (kernel != 'SunOS' || (kernel == 'SunOS' && Facter.value(:kernelrelease) == '5.11')) ? '/bin/ps' : '/usr/ucb/ps'
    ps_arg = kernel == 'SunOS' ? 'awwx' : '-ef'

    command = "#{base_path}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
nmConnect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"#{nodemanager_address}\",#{nodemanager_port},\"#{domain_name}\",\"#{domain_path}\",\"#{nm_protocol}\")
nmServerStatus(serverName=\"#{name}\", serverType=\"OHS\")
exit()
EOF"

    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''
    output = `su #{su_shell} - #{user} -c '#{command}'`
    Puppet.debug output
    output.each_line do |li|
      unless li.nil?
        if li.include? 'RUNNING'
          Puppet.debug 'found target'
          return 'Found'
        end
      end
    end
    'NotFound'
  end

  def start
    ohsserver_control :start
  end

  def stop
    ohsserver_control :stop
  end

  def restart
    ohsserver_control :stop
    ohsserver_control :start
  end

  def status
    output  = ohsserver_status
    Puppet.debug "ohsserver_status output #{output}"
    if output == 'Found'
      return :start
    else
      return :stop
    end
  end
end
