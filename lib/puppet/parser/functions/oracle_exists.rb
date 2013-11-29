# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:oracle_exists, :type => :rvalue) do |args|

      ora = lookupWlsVar('ora_inst_products')

      if ora == "empty"
        return false
      else
        software = args[0].strip
        if ora.include? software
          return true
        end
      end

      return false

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

