module Puppet::Parser::Functions
  newfunction(:osb_cluster_configured, :type => :rvalue) do |args|

    osb_exists = false

    if args[0].nil?
      return osb_exists
    else
      wlsDomain = args[0].strip.downcase
    end

    if args[1].nil?
      return osb_exists
    else
      target = args[1].strip.downcase
    end

    if args[2].nil?
      return osb_exists
    else
      wlsversion = args[2]
    end

    if wlsversion == 1212
      versionStr = "_1212"
    else
      versionStr = ""
    end

    prefix = "ora_mdw"+versionStr

    # check the middleware home
    mdw_count = lookupWlsVar(prefix+'_cnt')
    if mdw_count  == "empty"
      return osb_exists
    else
      # check the all mdw home
      i = 0
      while ( i < mdw_count.to_i)

        if wlsVarExists(prefix+'_'+i.to_s)
          
          mdw = lookupWlsVar(prefix+'_'+i.to_s)
          mdw = mdw.strip.downcase

          # how many domains are there in this mdw home
          domain_count = lookupWlsVar(prefix+'_'+i.to_s+'_domain_cnt')
          n = 0
          while ( n < domain_count.to_i )

            # lookup up domain
            if wlsVarExists(prefix+'_'+i.to_s+'_domain_'+n.to_s)
              domain = lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s)
              domain = domain.strip.downcase

              # do we found the right domain
              if domain == wlsDomain
                osb =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_osb')
                unless osb == "empty"
                  osb = osb.strip.downcase   
                  if osb.include? target
                    return true
                  end
                end

              end  # domain_path equal
            end # domain not nil
            n += 1

          end  # while domain

        end
        i += 1
      end # while mdw

    end # mdw count

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
