# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:wls_exists, :type => :rvalue) do |args|

    wls_exists = false

    mdwArg = args[0]

    # check the middleware home
    mdw_count = lookupWlsVar('ora_mdw_cnt')
    if mdw_count == "empty"
      return wls_exists
    else
      # check the all mdw home
      i = 0
      while ( i < mdw_count.to_i)
        mdw = lookupWlsVar('ora_mdw_'+i.to_s)
        unless mdw  == "empty"
          mdw = mdw.strip
          if mdw == mdwArg
            return true
          end
        end
        i += 1
      end

      #check for weblogic >= 12.1.2
        ora = lookupWlsVar('ora_inst_products')
        if ora == "empty"
          return false
        else
          software = args[0].strip
          if ora.include? software
            return true
          end
        end

    end
    return wls_exists
  end
end

def lookupWlsVar(name)
  #puts "lookup fact "+name
  if wlsVarExists(name)
    return lookupvar(name).to_s
  end
  return "empty"
end


def wlsVarExists(name)
  #puts "lookup fact "+name
  if lookupvar(name) != :undefined
    return true
  end
  return false 
end   
