begin
  require 'puppet/util/log'

  module Puppet::Parser::Functions
    newfunction(:domain_exists, :type => :rvalue) do |args|

      art_exists = false
      if args[0].nil?
        return art_exists
      else
        fullDomainPath = args[0].strip.downcase
      end

      log "domain_exists fullDomainPaths #{fullDomainPath}"

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
          unless domain == "empty"
            domain = domain.strip.downcase
            # do we found the right domain
            log "domain_exists compare #{fullDomainPath} with #{domain}"

            if domain == fullDomainPath
              return true
            end
          end
          n += 1
        end
      end

      return art_exists
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
      :source  => 'domain_exists'
    )  
  end

end
