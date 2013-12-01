# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:opatch_exists, :type => :rvalue) do |args|

    patch_exists  = false
    oracleHomeArg = args[0].strip.downcase
    oracleHome    = oracleHomeArg.gsub("/","_").gsub("\\","_").gsub("c:","_c").gsub("d:","_d").gsub("e:","_e")

    # check the oracle home patches
    all_opatches =  lookupWlsVar("ora_inst_patches#{oracleHome}")
    unless all_opatches == "empty"
      if all_opatches.include? args[1]
        return true
      end
    end
 
    return patch_exists

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
