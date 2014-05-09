require 'rexml/document' 

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

    if action == :present
      bsuaction = "-install"
    else 
      bsuaction = "-remove"
    end 

    Puppet.debug "bsu_patch action: #{action}"

    if patch_download_dir == nil
      command = "cd "+middleware_home_dir+"/utils/bsu;"+middleware_home_dir+"/utils/bsu/bsu.sh "+bsuaction+" -patchlist="+patchName+" -prod_dir="+weblogic_home_dir+" -verbose"
    else 
      command = "cd "+middleware_home_dir+"/utils/bsu;"+middleware_home_dir+"/utils/bsu/bsu.sh "+bsuaction+" -patchlist="+patchName+" -prod_dir="+weblogic_home_dir+" -patch_download_dir="+patch_download_dir+" -verbose"
    end 
    environment = ["USER="+user, "HOME=/home/"+user, "LOGNAME="+user]
    Puppet.debug "bsu_patch action: #{action} with command #{command}"

    output = Puppet::Util::Execution.execute command, :failonfail => true ,:uid => user ,:custom_environment => environment
    Puppet.debug "bsu_patch result: #{output}"

  end

  def bsu_status

    user                = resource[:os_user]
    patchName           = resource[:name]
    middleware_home_dir = resource[:middleware_home_dir]
    weblogic_home_dir   = resource[:weblogic_home_dir]
    jdk_home_dir        = resource[:jdk_home_dir]

    command   = jdk_home_dir+"/bin/java -Xms256m -Xmx256m -jar "+middleware_home_dir+"/utils/bsu/patch-client.jar -report -bea_home="+middleware_home_dir+" -output_format=xml"
    Puppet.debug "bsu_status for patch #{patchName} command: #{command}"

    output = Puppet::Util::Execution.execute command, :failonfail => true ,:uid => user
    doc = REXML::Document.new output
     
    root = doc.root
    root.elements.each("//patchDesc") do |patch|
      if patch.elements['patchId'].text == patchName
        Puppet.debug "found patch"
        return patchName
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