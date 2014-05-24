require 'utils/daemon'

class WlsDaemon < Daemon


  def self.run(user, domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl)
    identity = "wls-#{domain}"
    if daemonized?(identity)
      daemon_for(identity)
    else
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
    pass_domain
    pass_credentials

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

    def pass_credentials
      Puppet.info "Passing credintials to WLST"
      execute_command "weblogicUser = '#{@weblogicUser}'"
      execute_command "weblogicPassword = '#{@weblogicPassword}'"
    end   

    def pass_domain
      Puppet.info "Passing domain #{@domain}"
      execute_command "domain = '#{@domain}'"
    end

end
