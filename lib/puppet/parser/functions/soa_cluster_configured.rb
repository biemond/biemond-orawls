begin
  require 'puppet/util/log'

  module Puppet::Parser::Functions
    newfunction(:soa_cluster_configured, :type => :rvalue) do |args|

      soa_exists = false

      if args[0].nil?
        return soa_exists
      else
        fullDomainPath = args[0].strip.downcase
      end
      log "soa_cluster_configured fullDomainPath is #{fullDomainPath}"

      if args[1].nil?
        return soa_exists
      else
        target = args[1].strip.downcase
      end
      log "soa_cluster_configured target is #{target}"

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
          log "soa_cluster_configured found domain is #{domain}"

          unless domain == "empty"
            domain = domain.strip.downcase
            # do we found the right domain
            log "soa_cluster_configured compare domain #{domain} with #{fullDomainPath}"
            if domain == fullDomainPath
              soa =  lookupWlsVar(prefix+'_'+n.to_s+'_soa')
              log "soa_cluster_configured soa target is #{soa}"
              unless soa == "empty"
                soa = soa.strip.downcase   
                if soa.include? target
                  log "soa_cluster_configured return true"
                  return true
                end
              end
            end
          end
          n += 1
        end
      end

      return soa_exists
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
      :source  => 'soa_cluster_configured'
    )  
  end

end
