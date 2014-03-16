module Puppet::Parser::Functions
  newfunction(:soa_cluster_configured, :type => :rvalue) do |args|

    soa_exists = false

    if args[0].nil?
      return soa_exists
    else
      fullDomainPath = args[0].strip.downcase
    end

    if args[1].nil?
      return soa_exists
    else
      target = args[1].strip.downcase
    end

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
          if domain == fullDomainPath
            soa =  lookupWlsVar(prefix+'_'+n.to_s+'_soa')
            unless soa == "empty"
              soa = soa.strip.downcase   
              if soa.include? target
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
  #puts "lookup fact "+name
  if wlsVarExists(name)
    return lookupvar(name).to_s
  end
  #puts "return empty"
  return "empty"
end

def wlsVarExists(name)
  #puts "lookup fact "+name
  if lookupvar(name) != :undefined
    if lookupvar(name).nil?
      #puts "return false"
      return false
    end
    return true 
  end
  #puts "not found"
  return false 
end   
