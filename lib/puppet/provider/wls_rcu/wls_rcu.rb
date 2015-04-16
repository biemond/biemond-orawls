
Puppet::Type.type(:wls_rcu).provide(:wls_rcu) do

  def self.instances
    []
  end

  def rcu(action)
    Puppet.info "RCU #{action}"
    user         = resource[:os_user]
    statement    = resource[:statement]
    jdk_home_dir = resource[:jdk_home_dir]

    Puppet.info "rcu statement: #{statement}"

    output = `su - #{user} -c 'export JAVA_HOME=#{jdk_home_dir};export TZ=GMT;export LANG=en_US.UTF8;export LC_ALL=en_US.UTF8;export NLS_LANG=american_america;#{statement}'`
    Puppet.info "RCU result: #{output}"

    # Check for 'Repository Creation Utility - Create : Operation Completed' else raise
    result = false
    output.each_line do |li|
      unless li.nil?
        if li.include? 'Operation Completed'
          result = true
        end
      end
    end
    fail(output) if result == false
    Puppet.info 'RCU done'
  end

  def rcu_status
    Puppet.debug 'rcu_status'

    jdbcurl      = resource[:jdbc_url]
    sysuser      = resource[:sys_user]
    syspassword  = resource[:sys_password]
    user         = resource[:os_user]
    prefix       = resource[:name]
    oraclehome   = resource[:oracle_home]
    checkscript  = resource[:check_script]
    prefix       = resource[:name]

    Puppet.info "rcu for prefix #{prefix} execute SQL with #{oraclehome}/common/bin/wlst.sh #{checkscript}"
    rcu_output = `su - #{user} -c 'export TZ=GMT;#{oraclehome}/common/bin/wlst.sh #{checkscript} #{jdbcurl} #{syspassword} #{prefix} #{sysuser}'`
    fail ArgumentError, "Error executing puppet code, #{output}" if $CHILD_STATUS != 0
    Puppet.info "RCU check result: #{rcu_output}"
    rcu_output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}"
        if li.include? 'found'
          Puppet.info "found RCU #{prefix}"
          return prefix
        end
      end
    end
    'NotFound'
  end

  def present
    rcu :present
  end

  def absent
    rcu :absent
  end

  def status
    Puppet.debug 'status'

    output  = rcu_status
    prefix  = resource[:name]
    Puppet.info "rcu_status compare output #{output} with prefix #{prefix}"
    if output == prefix
      return :present
    else
      return :absent
    end
  end

end
