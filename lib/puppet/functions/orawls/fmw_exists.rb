require 'puppet/util/log'
# Check if the oracle home directory is already installed inside the middleware home
Puppet::Functions.create_function(:'orawls::fmw_exists') do

  # Check if the oracle home directory is already installed inside the middleware home
  # @param oracle_home the oracle home directory name
  # @return [Boolean] Return if it is found or not
  # @example Finding an oracle product
  #   orawls::fmw_exists('soa') => true
  dispatch :exists do
    param 'String', :oracle_home
    # return_type 'Boolean'
  end

  def exists(oracle_home)
    scope = closure_scope
    ora = scope['facts']['ora_inst_products']
    log "#{oracle_home} #{ora}"
    if ora == 'NotFound' or ora.nil?
      log 'return false because ora_inst_products fact is not found'
      return false
    else
      software = oracle_home.strip
      log "compare #{ora} with #{software}"

      if ora.include? software
        log 'return true because oracle_home is found'
        return true
      end
    end
    log 'return false because  oracle_home is not found'
    return false
  end

  def log(msg)
    Puppet::Util::Log.create(
      :level   => :info,
      :message => msg,
      :source  => 'orawls::fmw_exists'
    )
  end

end
