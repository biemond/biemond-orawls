require 'tempfile'
require 'fileutils'
require 'utils/settings'
require 'utils/wls_daemon'

require 'json'
require 'uri'
require 'net/http'

module Utils
  module WlsAccess
    include Settings

    DEFAULT_FILE = '/etc/wls_setting.yaml'

    def self.included(parent)
      parent.extend(WlsAccess)
    end

    # controller, this should determine based on the connect url if we do wlst(t3) or rest(http)
    def controller(content, parameters = {})
      action = ''
      unless parameters.nil?
        action = parameters['action']
        Puppet.info "Executing: action #{action}"
      else
        Puppet.info 'Executing: for a create, modify or destroy'
      end
      # check all domains of wls_settings if we need to use wlst or rest(>12.2.1)
      domains = configuration

      wls_type = 'wlst'
      domains.each do |key, domainValues|
        Puppet.info "domain found #{key}"
        wls_type = 'rest' if domainValues['connect_url'].include? "http"
      end

      if wls_type == 'wlst'
        case action
        when 'index' then
          # if index do all domains
          i = 1
          csv_string = ''
          domains.each do |key, domainValues|
            Puppet.info "domain found #{key}"
            result = wlst2 content, parameters, action, key, domains[key]
            if i > 1
              # with multi domain, remove first line if it is a header
              result = result.lines.to_a[1..-1].join
            end
            csv_string += result
            i += 1
          end
          return convert_csv_data_to_hash(csv_string, [], :col_sep => ';')
        else
          key = parameters['attributes'][0]['domain']
          wlst2 content, parameters, action, key, domains[key]
        end
      else
        case action
        when 'index' then
          # if index do all domains
          all_items = []
          domains.each do |key, domainValues|
            Puppet.info "domain found #{key}"
            result = rest action, key, domains[key], parameters
            all_items.concat result
          end
          return all_items
        else
          key = parameters['attributes'][0]['domain']
          rest action, key, domains[key], parameters
        end
      end
    end

    def rest(action, domain, domain_values, parameters = {})
      case action
      when 'index' then

        all_items = []
        weblogicUser       = domain_values['weblogic_user']     || 'weblogic'
        weblogicConnectUrl = domain_values['connect_url']       || 'http://localhost:7001'
        weblogicPassword   = domain_values['weblogic_password']

        uri_string = "#{weblogicConnectUrl}#{parameters['rest_url']}"
        Puppet.info uri_string

        uri = URI.parse(uri_string)

        http = Net::HTTP.new(uri.host, uri.port)
        # http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth weblogicUser, weblogicPassword
        request.add_field('Accept', 'application/json')

        response = http.request(request)

        case response
        when Net::HTTPSuccess
          items = JSON.parse(response.body)['items']

          items.each do |item|
            name = item['name']
            item['domain']  = domain
            item['name']    = "#{domain}/#{name}"
            all_items.push item
          end
        else
          fail response.body
        end
        all_items
      when 'create' then
        Puppet.info 'rest create action'
        Puppet.debug parameters['attributes']
        execute_rest(domain_values, parameters, 'Post')
        return nil
      when 'modify' then
        Puppet.info 'rest modify action'
        Puppet.debug parameters['attributes']
        execute_rest(domain_values, parameters, 'Post')
        return nil
      when 'destroy' then
        Puppet.info 'rest destroy action'
        Puppet.debug parameters['attributes']
        execute_rest(domain_values, parameters, 'Delete')
        return nil
      end
    end

    def wlst2(content, parameters = {}, action, domain, domain_values)
      script = 'wlstScript'

      tmpFile = Tempfile.new([script, '.py'])
      tmpFile.write(content)
      tmpFile.close
      FileUtils.chmod(0555, tmpFile.path)

      case action
      when 'index' then
        execute_wlst(script, tmpFile, parameters, domain, domain_values, :return_output => true)
      when 'execute' then
        execute_wlst(script, tmpFile, parameters, domain, domain_values, :return_output => true)
      else
        execute_wlst(script, tmpFile, parameters, domain, domain_values, :return_output => false)
      end
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

      case action
      when 'index' then
        # if index do all domains
        i = 1
        domains.each do |key, values|
          Puppet.info "domain found #{key}"
          csv_domain_string = execute_wlst(script, tmpFile, parameters, key, values, :return_output => true)
          if i > 1
            # with multi domain, remove first line if it is a header
            csv_domain_string = csv_domain_string.lines.to_a[1..-1].join
          end
          csv_string += csv_domain_string
          i += 1
        end
        convert_csv_data_to_hash(csv_string, [], :col_sep => ';')
      when 'execute' then
        domains.each do |key, values|
          # check content if we do this for the right domain
          if content.include? "real_domain='" + key
            csv_string = execute_wlst(script, tmpFile, parameters, key, values, :return_output => true)
          else
            Puppet.info "Skip WLST for domain #{key}"
          end
        end
        convert_csv_data_to_hash(csv_string, [], :col_sep => ';')
      else
        #  Puppet.info "domain found #{domain}"
        domains.each do |key, values|
          # check content if we do this for the right domain
          if content.include? "real_domain='" + key
            Puppet.info "Got the right domain #{key} script, now execute WLST"
            execute_wlst(script, tmpFile, parameters, key, values, :return_output => false)
          else
            Puppet.info "Skip WLST for domain #{key}"
          end
        end
      end
    end

    private

    def config_file
      Pathname.new(DEFAULT_FILE).expand_path
    end

    def execute_rest(domain, parameters, operation)
      array_size = parameters['attributes'].size

      weblogicUser       = domain['weblogic_user']     || 'weblogic'
      weblogicConnectUrl = domain['connect_url']       || 'http://localhost:7001'
      weblogicPassword   = domain['weblogic_password']

      uri = URI.parse("#{weblogicConnectUrl}/management/weblogic/latest/edit/changeManager/startEdit")

      http = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth weblogicUser, weblogicPassword
      request.add_field('Accept', 'application/json')
      request.add_field('Content-Type', 'application/json')
      request.add_field('X-Requested-By', 'MyClient')
      request.body = '{}'

      response = http.request(request)

      Puppet.debug 'startEdit'
      Puppet.debug response.code
      Puppet.debug response.body

      case response.code
      when '200'
        # loop all specific rest calls
        for i in 1..( array_size -1 )
          rest_url =  parameters['attributes'][i]['rest_url']
          attributes = parameters['attributes'][i]['attributes']
          Puppet.debug "#{weblogicConnectUrl}#{rest_url}"
          Puppet.debug attributes
          uri_create = URI.parse("#{weblogicConnectUrl}#{rest_url}")
          http_create = Net::HTTP.new(uri_create.host, uri_create.port)

          case operation
          when 'Post'
            request_create = Net::HTTP::Post.new(uri_create.request_uri)
          when 'Delete'
            request_create = Net::HTTP::Delete.new(uri_create.request_uri)
          end
          request_create.basic_auth weblogicUser, weblogicPassword
          request_create.add_field('Accept', 'application/json')
          request_create.add_field('Content-Type', 'application/json')
          request_create.add_field('X-Requested-By', 'MyClient')
          request_create.body = attributes.to_json

          response_create = http_create.request(request_create)
          Puppet.debug response_create.code
          Puppet.debug response_create.body

          case response_create.code
          when '200'
            Puppet.debug 'successful'
          when '201'
            Puppet.debug 'created'
          else
            uri_stop = URI.parse("#{weblogicConnectUrl}/management/weblogic/latest/edit/changeManager/cancelEdit")

            http_stop = Net::HTTP.new(uri_stop.host, uri_stop.port)

            request_stop = Net::HTTP::Post.new(uri_stop.request_uri)
            request_stop.basic_auth weblogicUser, weblogicPassword
            request_stop.add_field('Accept', 'application/json')
            request_stop.add_field('Content-Type', 'application/json')
            request_stop.add_field('X-Requested-By', 'MyClient')
            request_stop.body = '{}'

            response_stop = http_stop.request(request_stop)

            Puppet.debug 'stopEdit'
            Puppet.debug response_stop.code
            Puppet.debug response_stop.body
            raise response_stop.body
          end
        end

        uri_act = URI.parse("#{weblogicConnectUrl}/management/weblogic/latest/edit/changeManager/activate")
        http_act = Net::HTTP.new(uri_act.host, uri_act.port)

        request_act = Net::HTTP::Post.new(uri_act.request_uri)
        request_act.basic_auth weblogicUser, weblogicPassword
        request_act.add_field('Accept', 'application/json')
        request_act.add_field('Content-Type', 'application/json')
        request_act.add_field('X-Requested-By', 'MyClient')
        request_act.body = '{}'

        response_act = http_act.request(request_act)

        Puppet.debug 'activate'
        Puppet.debug response_act.code
        Puppet.debug response_act.body
      end
    end

    def execute_wlst(script, tmpFile, parameters, domain, domainValues, options = {})
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
      return_output              = options.fetch(:return_output) { false }

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
      File.read('/tmp/' + script + '.out') if return_output
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
