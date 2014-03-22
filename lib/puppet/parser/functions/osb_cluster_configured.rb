module Puppet::Parser::Functions
  newfunction(:osb_cluster_configured, :type => :rvalue) do |args|

    osb_exists = false

    if args[0].nil?
      return osb_exists
    else
      fullDomainPath = args[0].strip.downcase
    end
    Puppet.debug  "osb_cluster_configured fullDomainPath is #{fullDomainPath}"

    if args[1].nil?
      return osb_exists
    else
      target = args[1].strip.downcase
    end
    Puppet.debug  "osb_cluster_configured target is #{target}"

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
        Puppet.debug  "osb_cluster_configured found domain is #{domain}"
        unless domain == "empty"
          domain = domain.strip.downcase
          # do we found the right domain
          Puppet.debug  "osb_cluster_configured compare domain #{domain} with #{fullDomainPath}"
          if domain == fullDomainPath
            osb =  lookupWlsVar(prefix+'_'+n.to_s+'_osb')
            Puppet.debug  "osb_cluster_configured osb target is #{osb}"
            unless osb == "empty"
              osb = osb.strip.downcase   
              if osb.include? target
                Puppet.debug  "osb_cluster_configured return true"
                return true
              end
            end
          end
        end
        n += 1
      end
    end

    return osb_exists
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
