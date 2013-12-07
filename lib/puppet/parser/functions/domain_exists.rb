# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:domain_exists, :type => :rvalue) do |args|

    art_exists = false
    if args[0].nil?
      return art_exists
    else
      mdwArg = args[0].strip.downcase
    end

    if args[1].nil?
      return art_exists
    else
      wlsversion = args[1]
    end

    if args[2].nil?
      return art_exists
    else
      domainsHomeDir = args[2]
    end


    if wlsversion == 1212
      versionStr = "_1212"
    else
      versionStr = ""
    end

    prefix = "ora_mdw#{versionStr}"

    # check the middleware home
    mdw_count = lookupWlsVar(prefix+'_cnt')
    if mdw_count == "empty"
      return art_exists

    else
      # check the all mdw home
      i = 0
      while ( i < mdw_count.to_i)

        mdw = lookupWlsVar(prefix+'_'+i.to_s)

        unless mdw == "empty"
          mdw = mdw.strip.downcase

          # how many domains are there in this mdw home
          domain_count = lookupWlsVar(prefix+'_'+i.to_s+'_domain_cnt')
          n = 0
          while ( n < domain_count.to_i )

            # lookup up domain
            domain = lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s)
            unless domain == "empty"
              domain = domain.strip.downcase

              domain_path = domainsHomeDir + "/" + domain
              domain_path = domain_path.strip.downcase
              
              # do we found the right domain
              if domain_path == mdwArg
                return true
              end
            end
            n += 1

          end

        end
        i += 1
      end

    end

    return art_exists
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
