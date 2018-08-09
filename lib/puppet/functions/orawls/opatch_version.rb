require 'puppet/util/log'
# determine the opatch version of an oracle home
Puppet::Functions.create_function(:'orawls::opatch_version') do

  # determine the opatch version of an oracle home
  # @param oracle_home_path the full path to the oracle home directory
  # @return [String] Return opatch version
  # @example Finding an Oracle product
  #   orawls::opatch_version('/opt/oracle/db') => '11.1'
  dispatch :opatch_version do
    param 'String', :oracle_home_path
    # return_type 'String'
  end

  def opatch_version(oracle_home_path)

    oracle_home_path = oracle_home_path.strip.downcase
    oracle_home_path = oracle_home_path.gsub('/', '_').gsub('\\', '_').gsub('c:', '_c').gsub('d:', '_d').gsub('e:', '_e')
    log "stripped oracle home path #{oracle_home_path}"

    # check the opatch fact
    log "lookup fact orawls_inst_opatch#{oracle_home_path}"
    scope = closure_scope
    opatch = scope['facts']["orawls_inst_opatch#{oracle_home_path}"]
    if opatch == 'NotFound' or opatch.nil?
      log "fact not found return NotFound"
      return 'NotFound'
    else
      log "found value #{opatch}"
      return opatch
    end
    log 'end of function return NotFound'
    return 'NotFound'

  end

  def log(msg)
    Puppet::Util::Log.create(
      :level   => :info,
      :message => msg,
      :source  => 'orawls::opatch_version'
    )
  end
end