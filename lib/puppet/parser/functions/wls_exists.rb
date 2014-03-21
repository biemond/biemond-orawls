# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:wls_exists, :type => :rvalue) do |args|

    wls_exists = false

    mdwArg = args[0].strip
    Puppet.debug "mdw arg home #{mdwArg}"

    # check the middleware home
    mdw_count = lookupWlsVar('ora_mdw_cnt')
    if mdw_count == "empty"
      Puppet.debug "mdw_count is empty"
      return wls_exists
    else
      # check the all mdw home
      i = 0
      Puppet.debug "check the all mdw home start with #{i}"

      while ( i < mdw_count.to_i)
        mdw = lookupWlsVar('ora_mdw_'+i.to_s)
        Puppet.debug "found mdw #{mdw}"
        unless mdw  == "empty"
          mdw = mdw.strip
          Puppet.debug "check mdw #{mdw} with #{mdwArg}"
          if mdw == mdwArg
            return true
          end
        end
        i += 1
      end

      #check for weblogic >= 12.1.2
      Puppet.debug "check mdw 12.1.2 or higher"
      ora = lookupWlsVar('ora_inst_products')
      if ora == "empty"
        return false
      else
        software = mdwArg
        Puppet.debug "check for mdw 12.1.2 #{software} in #{ora}"
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
