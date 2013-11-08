# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:wls_exists, :type => :rvalue) do |args|

    wls_exists = false

    mdwArg = args[0]

    # check the middleware home
    mdw_count = lookupvar('ora_mdw_cnt')
    if mdw_count.nil?
      return wls_exists
    else
      # check the all mdw home
      i = 0
      while ( i < mdw_count.to_i)
        mdw = lookupvar('ora_mdw_'+i.to_s)
        unless mdw.nil?
          mdw = mdw.strip
          if mdw == mdwArg
            return true
          end
        end
        i += 1
      end

      #check for weblogic >= 12.1.2
      if lookupvar('ora_inst_products') != :undefined
        ora = lookupvar('ora_inst_products')
        if ora.nil?
          return false
        else
          software = args[0].strip
          if ora.include? software
            return true
          end
        end
      end

    end
    return wls_exists
  end
end

