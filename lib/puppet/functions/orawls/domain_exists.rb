require 'puppet/util/log'
# Check if the WebLogic domain already exists
Puppet::Functions.create_function(:'orawls::domain_exists') do

  # Check if the WebLogic domain already exists
  # @param full_domain_path the full path to the domain
  # @return [Boolean] Return if it is found or not
  # @example Finding a WebLogic oracle domain
  #   orawls::domain_exists('/opt/oracle/wlsdomains') => true
  dispatch :exists do
    param 'String', :full_domain_path
    # return_type 'Boolean'
  end

  def exists(full_domain_path)
    art_exists = false
    full_domain_path = full_domain_path.strip.downcase
    log "full domain path #{full_domain_path}"
    prefix = 'ora_mdw_domain'

    # check the middleware home
    scope = closure_scope
    domain_count = scope['facts'][prefix + '_cnt']
    log "total domains #{domain_count}"
    if domain_count == 'NotFound' or domain_count.nil?
      return art_exists
    else
      n = 0
      while n < domain_count.to_i

        # lookup up domain
        domain = scope['facts'][prefix + '_' + n.to_s]
        unless domain == 'NotFound'
          domain = domain.strip.downcase
          # do we found the right domain
          log "compare #{full_domain_path} with #{domain}"
          return true if domain == full_domain_path
        end
        n += 1
      end
    end

    return art_exists

  end

  def log(msg)
    Puppet::Util::Log.create(
      :level   => :info,
      :message => msg,
      :source  => 'orawls::domain_exists'
    )
  end

end