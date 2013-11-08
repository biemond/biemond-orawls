# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:opatch_exists, :type => :rvalue) do |args|

    patch_exists  = false
    oracleHomeArg = args[0].strip.downcase
    oracleHome    = oracleHomeArg.gsub("/","_").gsub("\\","_").gsub("c:","_c").gsub("d:","_d").gsub("e:","_e")

    # check the oracle home patches
    if lookupvar("ora_inst_patches#{oracleHome}") != :undefined
      all_opatches =  lookupvar("ora_inst_patches#{oracleHome}")
      unless all_opatches.nil?
        if all_opatches.include? args[1]
          return true
        end
      end
    end

    return patch_exists

  end
end
