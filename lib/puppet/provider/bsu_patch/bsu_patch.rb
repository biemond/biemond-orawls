
Puppet::Type.type(:bsu_patch).provide(:bsu_patch) do

  def self.instances
    []
  end

  def bsu_patch(action)
    user                = resource[:os_user]
    patchName           = resource[:name]
    middleware_home_dir = resource[:middleware_home_dir]
    weblogic_home_dir   = resource[:weblogic_home_dir]
    patch_download_dir  = resource[:patch_download_dir]
    temp_directory      = resource[:temp_directory]

    if action == :present
      bsuaction = "-install"
    else 
      bsuaction = "-remove"
    end 

    if temp_directory == nil
      tmpdir = "/tmp"
    else
      tmpdir = temp_directory
    end
    
    Puppet.debug "bsu_patch action: #{action}"

    if patch_download_dir == nil
      command = "cd "+middleware_home_dir+"/utils/bsu;"+middleware_home_dir+"/utils/bsu/bsu.sh "+bsuaction+" -patchlist="+patchName+" -prod_dir="+weblogic_home_dir+" -verbose"+" -Djava.io.tmpdir="+tmpdir
    else 
      command = "cd "+middleware_home_dir+"/utils/bsu;"+middleware_home_dir+"/utils/bsu/bsu.sh "+bsuaction+" -patchlist="+patchName+" -prod_dir="+weblogic_home_dir+" -patch_download_dir="+patch_download_dir+" -verbose"+" -Djava.io.tmpdir="+tmpdir
    end 
    #environment = ["USER="+user, "HOME=/home/"+user, "LOGNAME="+user]
    Puppet.debug "bsu_patch action: #{action} with command #{command}"
    output = `su - #{user} -c 'export USER="#{user}";export LOGNAME="#{user}";#{command}'`
    #output = Puppet::Util::Execution.execute command, :failonfail => true ,:uid => user ,:custom_environment => environment
    Puppet.debug "bsu_patch result: #{output}"
    
    # Check for 'Result: Success' else raise

    result = false
    output.each_line do |li|
      unless li.nil?
        if li.include? "Result: Success"
          result = true
        end
      end 
    end
    if result == false
      fail(output)
    end 

  end

  def bsu_status

    user                = resource[:os_user]
    patchName           = resource[:name]
    middleware_home_dir = resource[:middleware_home_dir]
    weblogic_home_dir   = resource[:weblogic_home_dir]
    jdk_home_dir        = resource[:jdk_home_dir]
    patch_download_dir  = resource[:patch_download_dir]
    temp_directory      = resource[:temp_directory]

    if temp_directory == nil
      tmpdir = "/tmp"
    else
      tmpdir = temp_directory
    end
    
    if patch_download_dir == nil
      command = "cd "+middleware_home_dir+"/utils/bsu;"+middleware_home_dir+"/utils/bsu/bsu.sh -view -status=applied -prod_dir="+weblogic_home_dir+" -verbose"+" -Djava.io.tmpdir="+tmpdir
    else 
      command = "cd "+middleware_home_dir+"/utils/bsu;"+middleware_home_dir+"/utils/bsu/bsu.sh -view -status=applied -prod_dir="+weblogic_home_dir+" -patch_download_dir="+patch_download_dir+" -verbose"+" -Djava.io.tmpdir="+tmpdir
    end 

    Puppet.debug "bsu_status for patch #{patchName} command: #{command}"
    output = `su - #{user} -c '#{command}'`
    # output = Puppet::Util::Execution.execute command, :failonfail => true ,:uid => user

    output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}" 
        if li.include? patchName
          Puppet.debug "found patch"
          return patchName
        end
      end 
    end
    return "NotFound"
  end

  def present
    bsu_patch :present
  end

  def absent
    bsu_patch :absent
  end

  def status
    output  = bsu_status
    patchId = resource[:name]
    Puppet.debug "bsu_status output #{output} for patchId #{patchId}"
    if output == patchId
      return :present
    else
      return :absent
    end
  end
end
