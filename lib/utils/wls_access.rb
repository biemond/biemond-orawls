require 'tempfile'
require 'fileutils'
require 'utils/settings'
#begin
#  require 'ruby-debug'
#  require 'pry'
#rescue LoadError
#  # do nothing 
#end


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

      if action == "index"
        csv_string = execute_wlst( script , tmpFile , parameters, action)
        convert_csv_data_to_hash(csv_string, [], :col_sep => ";")
      else
        execute_wlst( script , tmpFile , parameters , action)
      end 
    end


    private

      def config_file
        Pathname.new(DEFAULT_FILE).expand_path
      end

      def environment
        'default'  || 'default'
      end

      def operatingSystemUser
        setting_for('user') || "oracle"
      end

      def weblogicHomeDir
        setting_for('weblogic_home_dir')
      end

      def weblogicUser
        setting_for('weblogic_user') || "weblogic"
      end

      def weblogicConnectUrl
        setting_for('connect_url') || "t3://localhost:7001"
      end

      def weblogicPassword
        setting_for('weblogic_password') || "weblogic1"
      end

      def execute_wlst(script, tmpFile, parameters,action)
        command = ". #{weblogicHomeDir}/server/bin/setWLSEnv.sh;rm -f /tmp/#{script}.out;java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning #{tmpFile.path}"
        output = Puppet::Util::Execution.execute command, :failonfail => true ,:uid => operatingSystemUser
        if action == "index"
          File.read("/tmp/"+script+".out")
        end  
      end
  end
end