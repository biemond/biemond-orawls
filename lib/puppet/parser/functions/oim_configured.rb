begin
  require 'puppet/util/log'

  module Puppet::Parser::Functions
    newfunction(:oim_configured, :type => :rvalue) do |args|

      oim_exists = false

      if args[0].nil?
        return oim_exists
      else
        fullDomainPath = args[0].strip.downcase
      end
      log "oim_configured fullDomainPath is #{fullDomainPath}"

      prefix = "ora_mdw_domain"

      # check the middleware home
      domain_count = lookupWlsVar(prefix+'_cnt')
      if domain_count == "empty"
        return art_exists
      else
        n = 0
        while ( n < domain_count.to_i )

          # lookup up domain
          domain = lookupWlsVar(prefix+'_'+n.to_s)
          log "oim_configured found domain is #{domain}"
          unless domain == "empty"
            domain = domain.strip.downcase
            # do we found the right domain
            log "oim_configured compare domain #{domain} with #{fullDomainPath}"
            if domain == fullDomainPath
              oim =  lookupWlsVar(prefix+'_'+n.to_s+'_oim_configured')
              log "oim_configured has value #{oim}"
              unless oim == "empty"
                if oim == "true"
                  log "oim_configured return true"
                  return true
                end
              end
            end
          end
          n += 1
        end
      end

      return oim_exists
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
      :source  => 'oim_configured'
    )  
  end

end
