require 'utils/daemon'

class WlsDaemon < Daemon


  def self.run(user, domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl)
    identity = "wls-#{domain}"
    unless daemonized?(identity)
      new(user, domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl)
    end
  end

  def initialize(user, domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl)
    @user = user
    @domain = domain
    @weblogicHomeDir = weblogicHomeDir
    @weblogicUser = weblogicUser
    @weblogicPassword = weblogicPassword
    @weblogicConnectUrl = weblogicConnectUrl
    identity = "wls-#{domain}"
    Puppet.info "Starting the wls daemon for domain #{@domain}"
    command =  ". #{weblogicHomeDir}/server/bin/setWLSEnv.sh;java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning"
    super(identity, command, user )
    connect_to_wls
    set_domain
  end

  def execute_script(script, debug = false)
    Puppet.info "Executing wls-script #{script}"
    execute_command "execfile('#{script}')"
    sync
  end

  private

    def connect_to_wls
      Puppet.info "Connecting to wls on url #{@weblogicConnectUrl}"
      execute_command "connect('#{@weblogicUser}','#{@weblogicPassword}','#{@weblogicConnectUrl}')"
    end

    def set_domain
      Puppet.info "Setting domain to  #{@domain}"
      execute_command "domain = '#{@domain}'"
    end

end
