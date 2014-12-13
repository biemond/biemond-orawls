class WlsDaemon < EasyType::Daemon
  DEFAULT_TIMEOUT = 120 # 2 minutes

  def self.run(user, domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl, postClasspath)
    daemon = super("wls-#{domain}")
    if daemon
      return daemon
    else
      new(user, domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl, postClasspath)
    end
  end

  def initialize(user, domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl, postClasspath)
    @user = user
    @domain = domain
    @weblogicHomeDir = weblogicHomeDir
    @weblogicUser = weblogicUser
    @weblogicPassword = weblogicPassword
    @weblogicConnectUrl = weblogicConnectUrl
    @postClasspath = postClasspath
    identity = "wls-#{domain}"
    Puppet.info "Starting the wls daemon for domain #{@domain}"
    command =  "export POST_CLASSPATH='#{@postClasspath}';. #{weblogicHomeDir}/server/bin/setWLSEnv.sh;java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning"
    super(identity, command, user)
    pass_domain
    pass_credentials
    connect_to_wls
  end

  def execute_script(script, timeout = DEFAULT_TIMEOUT)
    Puppet.info "Executing wls-script #{script} with timeout = #{timeout}"
    pass_domain
    pass_credentials
    connect_to_wls
    execute_command "execfile('#{script}')"
    sync(timeout)
  end

  private

  def connect_to_wls
    Puppet.info "Connecting to wls on url #{@weblogicConnectUrl}"
    execute_command "connect('#{@weblogicUser}','#{@weblogicPassword}','#{@weblogicConnectUrl}')"
  end

  def pass_credentials
    Puppet.debug 'Passing credintials to WLST'
    execute_command "weblogicUser = '#{@weblogicUser}'"
    execute_command "weblogicPassword = '#{@weblogicPassword}'"
  end

  def pass_domain
    Puppet.debug "Passing domain #{@domain}"
    execute_command "domain = '#{@domain}'"
  end
end
