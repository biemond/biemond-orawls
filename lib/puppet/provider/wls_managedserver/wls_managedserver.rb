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
    adminserver_address       = resource[:adminserver_address]
    adminserver_port          = resource[:adminserver_port]

    if action == :start
      wls_action = "start(\"#{name}\",\"#{target}\")"
    else
      wls_action = "shutdown(\"#{name}\",\"#{target}\",force=\"true\")"
    end

    command = "#{weblogic_home_dir}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
connect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"t3://#{adminserver_address}:#{adminserver_port}\")
try:
    #{wls_action}
except:
    domainRuntime()
    cd(\"/ServerLifeCycleRuntimes/#{name}\")
    serverState = cmo.getState()
    if serverState == \"ADMIN\":
        resume(\"#{name}\")
    else:
        raise

exit()
EOF"

    Puppet.debug "managedserver action: #{action} with command #{command}"
    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''

    if Puppet.features.root?
        output = `su #{su_shell} - #{user} -c '#{command}'`
    else
        output = `#{command}`
    end
    
    Puppet.debug "managedserver result: #{output}"
  end

  def managedserver_status
    domain_name         = resource[:domain_name]
    name                = resource[:server_name]
    target              = resource[:target]
    user                = resource[:os_user]
    weblogic_home_dir   = resource[:weblogic_home_dir]
    weblogic_user       = resource[:weblogic_user]
    weblogic_password   = resource[:weblogic_password]
    adminserver_address = resource[:adminserver_address]
    adminserver_port    = resource[:adminserver_port]

    kernel = Facter.value(:kernel)

    # ps_bin = (kernel != 'SunOS' || (kernel == 'SunOS' && Facter.value(:kernelrelease) == '5.11')) ? '/bin/ps' : '/usr/ucb/ps'
    # ps_arg = kernel == 'SunOS' ? 'awwx' : '-ef'

    # command  = "#{ps_bin} #{ps_arg} | /bin/grep -v grep | /bin/grep 'weblogic.Name=#{name}' | /bin/grep #{domain_name}"

    # Puppet.debug "managedserver_status #{command}"
    # output = `#{command}`
    # Puppet.info output
    # output.each_line do |li|
    #   unless li.nil?
    #     if li.include? name
    #       Puppet.debug 'found server'
    #       return 'Found'
    #     end
    #   end
    # end

    command = "#{weblogic_home_dir}/common/bin/wlst.sh -skipWLSModuleScanning <<-EOF
connect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"t3://#{adminserver_address}:#{adminserver_port}\")
state(\"#{name}\",\"#{target}\")
exit()
EOF"
    # kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''

    if Puppet.features.root?
        output = `su #{su_shell} - #{user} -c '#{command}'`
    else
        output = `#{command}`
    end
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
    name    = resource[:server_name]
    target  = resource[:target]
    output  = managedserver_status
    Puppet.info "managedserver_status #{name} type #{target} output #{output}"
    if output == 'Found'
      return :start
    else
      return :stop
    end
  end
end
