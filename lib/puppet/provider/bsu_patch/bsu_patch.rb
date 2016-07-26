
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
      bsuaction = '-install'
    else
      bsuaction = '-remove'
    end

    Puppet.debug "bsu_patch action: #{action}"

    if patch_download_dir.nil?
      command = 'cd ' + middleware_home_dir + '/utils/bsu;' + middleware_home_dir + '/utils/bsu/bsu.sh ' + bsuaction + ' -patchlist=' + patchName + ' -prod_dir=' + weblogic_home_dir + ' -verbose'
    else
      command = 'cd ' + middleware_home_dir + '/utils/bsu;' + middleware_home_dir + '/utils/bsu/bsu.sh ' + bsuaction + ' -patchlist=' + patchName + ' -prod_dir=' + weblogic_home_dir + ' -patch_download_dir=' + patch_download_dir + ' -verbose'
    end

    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''

    Puppet.debug "bsu_patch action: #{action} with command #{command}"
    if Puppet.features.root?
        output = `su #{su_shell} - #{user} -c 'export USER="#{user}";export LOGNAME="#{user}";#{command}'`
    else
        output = `export USER="#{user}";export LOGNAME="#{user}";#{command}`
    end
    Puppet.info "bsu_patch result: #{output}"

    # Check for 'Result: Success' else raise

    result = false
    output.each_line do |li|
      unless li.nil?
        if li.include? 'Result: Success'
          result = true
        end
      end
    end
    fail(output) if result == false
    Puppet.info 'bsu_patch done'
  end

  def bsu_status
    user                = resource[:os_user]
    patchName           = resource[:name]
    middleware_home_dir = resource[:middleware_home_dir]
    weblogic_home_dir   = resource[:weblogic_home_dir]
    patch_download_dir  = resource[:patch_download_dir]

    if patch_download_dir.nil?
      command = 'cd ' + middleware_home_dir + '/utils/bsu;' + middleware_home_dir + '/utils/bsu/bsu.sh -view -status=applied -prod_dir=' + weblogic_home_dir + ' -verbose'
    else
      command = 'cd ' + middleware_home_dir + '/utils/bsu;' + middleware_home_dir + '/utils/bsu/bsu.sh -view -status=applied -prod_dir=' + weblogic_home_dir + ' -patch_download_dir=' + patch_download_dir + ' -verbose'
    end

    kernel = Facter.value(:kernel)
    su_shell = kernel == 'Linux' ? '-s /bin/bash' : ''

    Puppet.debug "bsu_status for patch #{patchName} command: #{command}"
    if Puppet.features.root?
        output = `su #{su_shell} - #{user} -c '#{command}'`
    else
        output = `#{command}`
    end

    output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}"
        if li.include? patchName
          Puppet.debug 'found patch'
          return patchName
        end
      end
    end
    'NotFound'
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
