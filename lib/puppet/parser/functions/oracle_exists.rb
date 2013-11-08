# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:oracle_exists, :type => :rvalue) do |args|
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

      return false

    else
      return false
    end

  end
end

