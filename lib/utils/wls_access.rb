require 'tempfile'
require 'fileutils'
require 'utils/settings'
require 'utils/wls_daemon'

module Utils
  module WlsAccess

    include Settings

    DEFAULT_FILE = "/etc/wls_setting.yaml"

    def self.included(parent)
      parent.extend(WlsAccess)
    end

    def wlst( content, parameters = {})

      script = "wlstScript"
      action = ""
      unless parameters.nil?
        action = parameters["action"]
        Puppet.info "Executing: #{script} with action #{action}"
      else
        Puppet.info "Executing: #{script} for a create,modify or destroy"
      end

      tmpFile = Tempfile.new([ script, '.py' ])
      tmpFile.write(content)
      tmpFile.close
      FileUtils.chmod(0555, tmpFile.path)

      csv_string = ""
      domains = configuration()

      if action == "index"
        # if index do all domains
        i = 1
        domains.each { |key, values|
          Puppet.info "domain found #{key}"
          csv_domain_string = execute_wlst( script , tmpFile , parameters,key,values, action)
          if i > 1
            # with multi domain, remove first line if it is a header
            csv_domain_string = csv_domain_string.lines.to_a[1..-1].join
          end
          csv_string += csv_domain_string
          i += 1
        }
        convert_csv_data_to_hash(csv_string, [], :col_sep => ";")
      else
        #  Puppet.info "domain found #{domain}"
        domains.each { |key, values|
          # check content if we do this for the right domain
          if content.include? "real_domain='"+key
            Puppet.info "Got the right domain #{key} script, now execute WLST"
            execute_wlst( script , tmpFile , parameters,key,values, action)
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

      def execute_wlst(script, tmpFile, parameters, domain , domainValues, action)
        operatingSystemUser = domainValues['user']              || "oracle"
        weblogicHomeDir     = domainValues['weblogic_home_dir']
        weblogicUser        = domainValues['weblogic_user']     || "weblogic"
        weblogicConnectUrl  = domainValues['connect_url']       || "t3://localhost:7001"
        weblogicPassword    = domainValues['weblogic_password'] || "weblogic1"
        postClasspath       = domainValues['post_classpath'] || ""

        wls_daemon = WlsDaemon.run(operatingSystemUser,domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl, postClasspath )
        wls_daemon.execute_script( tmpFile.path)
        if action == "index"
          File.read("/tmp/"+script+".out")
        end
      end

  end
end