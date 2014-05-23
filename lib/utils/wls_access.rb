require 'tempfile'
require 'fileutils'
require 'utils/settings'
require 'open3'

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

        require 'ruby-debug'
        debugger
        prepare_detached_process(operatingSystemUser,domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl )
        execute_wls_script( tmpFile.path)
        if action == "index"
          File.read("/tmp/"+script+".out")
        end
      end


      def prepare_detached_process(user, domain, weblogicHomeDir, weblogicUser, weblogicPassword, weblogicConnectUrl)
        @stdin, @stdout , @stderr = Open3.popen3("su - #{user}") unless @stdin
        @stdin.puts ". #{weblogicHomeDir}/server/bin/setWLSEnv.sh;java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning"
        @stdin.puts "connect('#{weblogicUser}','#{weblogicPassword}','#{weblogicConnectUrl}')"
        @stdin.puts "domain = '#{domain}'"
      end


      def execute_wls_script(script)
        @stdin.puts("execfile('#{script}')")
        wait_for_finish
      end

      def wait_for_finish
        @stdout.each_line do |line|
          puts "skip: #{line}"
          break if line == "~~~~\n"
        end
      end


  end
end