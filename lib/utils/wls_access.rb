require 'tempfile'
require 'fileutils'
require 'utils/settings'
require 'utils/wls_daemon'

module Utils
  module WlsAccess
    include Settings

    DEFAULT_FILE = '/etc/wls_setting.yaml'

    def self.included(parent)
      parent.extend(WlsAccess)
    end

    def wlst(content, parameters = {})
      script = 'wlstScript'
      action = ''
      unless parameters.nil?
        action = parameters['action']
        Puppet.info "Executing: #{script} with action #{action}"
      else
        Puppet.info "Executing: #{script} for a create,modify or destroy"
      end

      tmpFile = Tempfile.new([script, '.py'])
      tmpFile.write(content)
      tmpFile.close
      FileUtils.chmod(0555, tmpFile.path)

      csv_string = ''
      domains = configuration

      if action == 'index'
        # if index do all domains
        i = 1
        domains.each { |key, values|
          Puppet.info "domain found #{key}"
          csv_domain_string = execute_wlst(script, tmpFile, parameters, key, values, action)
          if i > 1
            # with multi domain, remove first line if it is a header
            csv_domain_string = csv_domain_string.lines.to_a[1..-1].join
          end
          csv_string += csv_domain_string
          i += 1
        }
        convert_csv_data_to_hash(csv_string, [], :col_sep => ';')
      else
        #  Puppet.info "domain found #{domain}"
        domains.each { |key, values|
          # check content if we do this for the right domain
          if content.include? "real_domain='" + key
            Puppet.info "Got the right domain #{key} script, now execute WLST"
            execute_wlst(script, tmpFile, parameters, key, values, action)
          else
            Puppet.info "Skip WLST for domain #{key}"
          end
        }
      end
    end

    private

    def config_file
      Pathname.new(DEFAULT_FILE).expand_path
    end

    def execute_wlst(script, tmpFile, parameters, domain, domainValues, action)
      operatingSystemUser       = domainValues['user']              || 'oracle'
      weblogicHomeDir           = domainValues['weblogic_home_dir']
      weblogicUser              = domainValues['weblogic_user']     || 'weblogic'
      weblogicConnectUrl        = domainValues['connect_url']       || 't3://localhost:7001'
      weblogicPassword          = domainValues['weblogic_password']
      postClasspath             = domainValues['post_classpath']
      custom_trust              = domainValues['custom_trust']
      trust_keystore_file       = domainValues['trust_keystore_file']
      trust_keystore_passphrase = domainValues['trust_keystore_passphrase']
      debug_module              = domainValues['debug_module']
      archive_path              = domainValues['archive_path']

      fail('weblogic_home_dir cannot be nil, check the wls_setting resource type') if weblogicHomeDir.nil?
      fail('weblogic_password cannot be nil, check the wls_setting resource type') if weblogicPassword.nil?

      debugmode = Puppet::Util::Log.level
      if debugmode.to_s == 'debug'
        puts 'Prepare to run: ' + tmpFile.path + ',' +  operatingSystemUser + ',' +  domain + ',' +  weblogicHomeDir + ',' +  weblogicUser + ',' +  weblogicPassword + ',' +  weblogicConnectUrl
        puts 'vvv==================================================================='
        File.open(tmpFile.path).readlines.each do |line|
          puts line
        end
        puts '^^^===================================================================='
      end

      wls_daemon = WlsDaemon.run(operatingSystemUser, domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl, postClasspath, custom_trust, trust_keystore_file, trust_keystore_passphrase)

      if debug_module.to_s == 'true'
        if !File.directory?(archive_path)
          FileUtils.mkdir(archive_path)
        end
        FileUtils.cp(tmpFile.path, archive_path)
      end

      if timeout_specified
        wls_daemon.execute_script(tmpFile.path, timeout_specified)
      else
        wls_daemon.execute_script(tmpFile.path)
      end
      File.read('/tmp/' + script + '.out') if action == 'index'
    end

    def timeout_specified
      if respond_to?(:to_hash)
        to_hash.fetch(:timeout) { nil } #
      else
        nil
      end
    end
  end
end
