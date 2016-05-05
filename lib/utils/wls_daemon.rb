class WlsDaemon < EasyType::Daemon
  include EasyType::Template

  DEFAULT_TIMEOUT = 120 # 2 minutes

  def self.run(user,
               domain,
               weblogicHomeDir,
               weblogicUser,
               weblogicPassword,
               weblogicConnectUrl,
               postClasspath,
               custom_trust,
               trust_keystore_file,
               trust_keystore_passphrase,
               use_default_value_when_empty)
    daemon = super("wls-#{domain}")
    if daemon
      return daemon
    else
      new(user, domain, weblogicHomeDir, weblogicUser, weblogicPassword,
          weblogicConnectUrl, postClasspath, custom_trust, trust_keystore_file,
          trust_keystore_passphrase, use_default_value_when_empty)
    end
  end

  def initialize(user,
                 domain,
                 weblogicHomeDir,
                 weblogicUser,
                 weblogicPassword,
                 weblogicConnectUrl,
                 postClasspath,
                 custom_trust,
                 trust_keystore_file,
                 trust_keystore_passphrase,
                 use_default_value_when_empty)
    @user = user
    @domain = domain
    @weblogicHomeDir = weblogicHomeDir
    @weblogicUser = weblogicUser
    @weblogicPassword = weblogicPassword
    @weblogicConnectUrl = weblogicConnectUrl
    @postClasspath = postClasspath
    @custom_trust = custom_trust
    @trust_keystore_file = trust_keystore_file
    @trust_keystore_passphrase = trust_keystore_passphrase
    @use_default_value_when_empty = use_default_value_when_empty

    if @custom_trust.to_s == 'true'
      trust_parameters = "-Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=#{@trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=#{@trust_keystore_passphrase}"
      Puppet.debug "trust parameters #{trust_parameters}"
    else
      Puppet.debug 'no custom trust'
    end

    identity = "wls-#{domain}"
    Puppet.info "Starting the wls daemon for domain #{@domain}"
    command =  "export POST_CLASSPATH='#{@postClasspath}';. #{weblogicHomeDir}/server/bin/setWLSEnv.sh;java -Dweblogic.security.SSL.ignoreHostnameVerification=true #{trust_parameters} weblogic.WLST"
    super(identity, command, user)
    define_common_methods
  end

  def execute_script(script, timeout = DEFAULT_TIMEOUT)
    Puppet.info "Executing wls-script #{script} with timeout = #{timeout}"
    pass_domain
    pass_use_default_value_when_empty
    pass_credentials
    connect_to_wls
    execute_command "execfile('#{script}')"
    sync(timeout)
  end

  def execute_script_simple(script)
    Puppet.info "Executing wls-script #{script}"
    execute_command "execfile('#{script}')"
  end

  private

  def connect_to_wls
    Puppet.info "Connecting to wls on url #{@weblogicConnectUrl}"
    execute_command "connect('#{@weblogicUser}','#{@weblogicPassword}','#{@weblogicConnectUrl}')"
  end

  def pass_credentials
    Puppet.debug 'Passing credentials to WLST'
    execute_command "weblogicUser = '#{@weblogicUser}'"
    execute_command "weblogicPassword = '#{@weblogicPassword}'"
  end

  def pass_domain
    Puppet.debug "Passing domain #{@domain}"
    execute_command "domain = '#{@domain}'"
  end

  def pass_use_default_value_when_empty
    if @use_default_value_when_empty.to_s == 'true'
      empty_value = 'True'
    else
      empty_value = 'False'
    end
    Puppet.debug "Passing use_default_value_when_empty #{empty_value}"
    execute_command "use_default_value_when_empty = #{empty_value}"
  end

  def define_common_methods
    Puppet.debug 'Defining common methods...'
    tmpFile = Tempfile.new('wlstCommonScript.py')
    tmpFile.write(template('puppet:///modules/orawls/wlst/common.py.erb', binding))
    tmpFile.close
    FileUtils.chmod(0555, tmpFile.path)
    execute_script_simple(tmpFile.path)
    # execute_command template('puppet:///modules/orawls/wlst/common.py.erb', binding)
  end
end
