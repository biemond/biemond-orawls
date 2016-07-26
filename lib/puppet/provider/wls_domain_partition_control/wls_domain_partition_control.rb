Puppet::Type.type(:wls_domain_partition_control).provide(:wls_domain_partition_control) do

  def self.instances
    []
  end

  def domain_partition_control(action)
    Puppet.debug "domain_partition action: #{action}"

    name                      = resource[:domain_partition]
    user                      = resource[:os_user]
    middleware_home_dir       = resource[:middleware_home_dir]
    weblogic_user             = resource[:weblogic_user]
    weblogic_password         = resource[:weblogic_password]
    adminserver_address       = resource[:adminserver_address]
    adminserver_port          = resource[:adminserver_port]

    if action == :start
      wls_action = 'cmo.start()'
    else
      wls_action = 'cmo.shutdown()'
    end

    command = "#{middleware_home_dir}/oracle_common/common/bin/wlst.sh <<-EOF
connect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"t3://#{adminserver_address}:#{adminserver_port}\")
domainRuntime()
cd(\"/DomainPartitionRuntimes/#{name}/PartitionLifeCycleRuntime/#{name}\")
#{wls_action}
exit()
EOF"

    Puppet.debug "domain_partition_control action: #{action} with command #{command}"
    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''

    if Puppet.features.root?
        output = `su #{su_shell} - #{user} -c '#{command}'`
    else
        output = `#{command}`
    end
    Puppet.debug "domain_partition_control result: #{output}"
  end

  def domain_partition_control_status
    name                = resource[:domain_partition]
    user                = resource[:os_user]
    middleware_home_dir = resource[:middleware_home_dir]
    weblogic_user       = resource[:weblogic_user]
    weblogic_password   = resource[:weblogic_password]
    adminserver_address = resource[:adminserver_address]
    adminserver_port    = resource[:adminserver_port]

    command = "#{middleware_home_dir}/oracle_common/common/bin/wlst.sh <<-EOF
connect(\"#{weblogic_user}\",\"#{weblogic_password}\",\"t3://#{adminserver_address}:#{adminserver_port}\")
domainRuntime()
cd(\"/DomainPartitionRuntimes/#{name}/PartitionLifeCycleRuntime/#{name}\")
cmo.getState()
exit()
EOF"

    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''

    Puppet.debug "domain_partition_control status with command #{command}"

    if Puppet.features.root?
        output = `su #{su_shell} - #{user} -c '#{command}'`
    else
        output = `#{command}`
    end
    Puppet.debug output
    output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}"
        if li.include? 'RUNNING'
          Puppet.debug 'found domain partition'
          return 'Found'
        end
      end
    end
  end

  def start
    domain_partition_control :start
  end

  def stop
    domain_partition_control :stop
  end

  def restart
    domain_partition_control :stop
    domain_partition_control :start
  end

  def status
    output  = domain_partition_control_status
    Puppet.debug "domain_partition_control_status output #{output}"
    if output == 'Found'
      return :start
    else
      return :stop
    end
  end
end
