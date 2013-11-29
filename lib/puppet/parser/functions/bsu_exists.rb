# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:bsu_exists, :type => :rvalue) do |args|

    art_exists = false
    mdwArg = args[0].strip.downcase

    # check the middleware home
    mdw_count = lookupWlsVar('ora_mdw_cnt')
    if mdw_count == "empty"
      return art_exists

    else

      # check the all mdw home
      i = 0
      while ( i < mdw_count.to_i)

        mdw = lookupWlsVar('ora_mdw_'+i.to_s)

        unless mdw  == "empty"
          mdw = mdw.strip.downcase
          # do we found the right mdw
          if mdw == mdwArg
            # check patches
              all_bsu =  lookupWlsVar('ora_mdw_'+i.to_s+'_bsu')
              unless all_bsu == "empty"
                if all_bsu.include? args[1]
                  return true
                end
              end

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
  return "empty"
end


def wlsVarExists(name)
  #puts "lookup fact "+name
  if lookupvar(name) != :undefined
    return true
  end
  return false 
end   

