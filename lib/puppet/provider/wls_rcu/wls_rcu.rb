
Puppet::Type.type(:wls_rcu).provide(:wls_rcu) do

  def self.instances
    []
  end

  def rcu(action)

    Puppet.info "RCU #{action}"
    user        = resource[:os_user]
    statement   = resource[:statement]
    oracle_home = resource[:oracle_home]

    environment = "SQLPLUS_HOME=#{oracle_home}"
    Puppet.debug "rcu statement: #{statement}"

    output = execute statement, :failonfail => true ,:uid => user, :custom_environment => environment
    Puppet.info "RCU result: #{output}"

  end

  def rcu_status

    Puppet.debug "rcu_status"

    oracle_home             = resource[:oracle_home]
    sys_password            = resource[:sys_password]
    user                    = resource[:os_user]
    prefix                  = resource[:name]
    db_service              = resource[:db_service]
    db_server               = resource[:db_server]

    sql = <<-EOS
set term off echo off pages 0 colsep '|' trimspool on
spool /tmp/check_rcu_#{prefix}2.txt
select distinct 'found' from system.schema_version_registry where mrc_name ='#{prefix}';
grant execute on sys.dbms_job to PUBLIC;
grant execute on sys.dbms_reputil to PUBLIC;
spool off
exit 
EOS
    
    # if FileTest.exists?("/tmp/check_rcu_#{prefix}2.txt")
    #   File.delete("/tmp/check_rcu_DEV2.txt")
    # end

    tmpFile = Tempfile.new([ "rcuCheck", '.sql' ])
    tmpFile.write(sql)
    tmpFile.close
    FileUtils.chmod(0555, tmpFile.path)

    Puppet.debug "rcu for prefix #{prefix} execute SQL"
    output = `su - #{user} -c 'export ORACLE_HOME=#{oracle_home};LD_LIBRARY_PATH=#{oracle_home}/lib;#{oracle_home}/bin/sqlplus \"sys/#{sys_password}@//#{db_server}/#{db_service} as sysdba\" @#{tmpFile.path}'`
    raise ArgumentError, "Error executing puppet code, #{output}" if $? != 0
    
    if FileTest.exists?("/tmp/check_rcu_#{prefix}2.txt") 
      File.open("/tmp/check_rcu_#{prefix}2.txt") do | output|
        output.each_line do |li|
          unless li.nil?
            Puppet.debug "line #{li}" 
            if ( (li.include? "found") and !(li.include? "select" ))
              Puppet.debug "found RCU #{prefix}"
              return prefix
            end
          end 
        end
      end
    else 
      return "NoOutput"  
    end
    return "NotFound"
  end

  def present
    rcu :present
  end

  def absent
    rcu :absent
  end

  def status
    Puppet.debug "status"

    if resource[:oracle_home].nil? 
      if resource[:ensure] == :present
        return :absent
      else 
        return :present 
      end  
    end  

    output  = rcu_status
    prefix  = resource[:name]
    Puppet.info "rcu_status output #{output} for prefix #{prefix}"
    if output == prefix
      return :present
    else
      return :absent
    end
  end

end