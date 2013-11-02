# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:bsu_exists, :type => :rvalue) do |args|
    
    art_exists = false
    mdwArg = args[0].strip.downcase

    # check the middleware home
    mdw_count = lookupvar('ora_mdw_cnt')
    if mdw_count.nil?
      return art_exists

    else

      # check the all mdw home
      i = 0
      while ( i < mdw_count.to_i) 

        mdw = lookupvar('ora_mdw_'+i.to_s)

        unless mdw.nil?
          mdw = mdw.strip.downcase
          os = lookupvar('operatingsystem')
          if os == "windows"
            mdw = mdw.gsub("\\","/")
            mdwArg = mdwArg.gsub("\\","/")
          end 

          # do we found the right mdw
          if mdw == mdwArg 
            # check patches
            if lookupvar('ora_mdw_'+i.to_s+'_bsu') != :undefined
              all_bsu =  lookupvar('ora_mdw_'+i.to_s+'_bsu')
              unless all_bsu.nil?
                if all_bsu.include? args[1]
                  return true
                end
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

