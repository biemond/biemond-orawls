begin
  require 'puppet/util/log'

  module Puppet::Parser::Functions
    newfunction(:orawls_oracle_exists, :type => :rvalue) do |args|

      ora = lookupWlsVar('ora_inst_products')
      log "oracle_exists #{args[0]} #{ora}"
      if ora == "empty"
        return false
      else
        software = args[0].strip
        log "oracle_exists compare #{ora} with #{software}"

        if ora.include? software
          log "oracle_exists return true"
          return true
        end
      end
      log "oracle_exists return false"
      return false

    end
  end

  def lookupWlsVar(name)
    if wlsVarExists(name)
      return lookupvar(name).to_s
    end
    return "empty"
  end

  def wlsVarExists(name)
    if lookupvar(name) != :undefined
      if lookupvar(name).nil?
        return false
      end
      return true 
    end
    return false 
  end   

  def log(msg)
    Puppet::Util::Log.create(
      :level   => :info,
      :message => msg,
      :source  => 'orawls_oracle_exists'
    )  
  end

end
