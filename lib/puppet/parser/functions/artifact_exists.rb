# restart the puppetmaster when changed
module Puppet::Parser::Functions
  newfunction(:artifact_exists, :type => :rvalue) do |args|

    art_exists = false
    if args[0].nil?
      return art_exists
    else
      wlsDomain = args[0].strip.downcase
    end

    if args[1].nil?
      return art_exists
    else
      type = args[1].strip.downcase
    end

    if args[2].nil?
      return art_exists
    else
      wlsObject = args[2].strip
    end

    if ( type == 'resource' or type == 'resource_entry'  )
      if args[3].nil?
        return art_exists
      else
        subType = args[3].strip
      end
      if args[4].nil?
        return art_exists
      else
        wlsversion = args[4]
      end
    else
      if args[3].nil?
        return art_exists
      else
        wlsversion = args[3]
      end
    end

    if wlsversion == 1212
      versionStr = "_1212"
    else
      versionStr = ""
    end

    prefix = "ora_mdw"+versionStr

    # check the middleware home
    mdw_count = lookupWlsVar(prefix+'_cnt')
    if mdw_count  == "empty"
      return art_exists
    else
      # check the all mdw home
      i = 0
      while ( i < mdw_count.to_i)

        if wlsVarExists(prefix+'_'+i.to_s)
          
          mdw = lookupWlsVar(prefix+'_'+i.to_s)
          mdw = mdw.strip.downcase

          # how many domains are there in this mdw home
          domain_count = lookupWlsVar(prefix+'_'+i.to_s+'_domain_cnt')
          n = 0
          while ( n < domain_count.to_i )

            # lookup up domain
            if wlsVarExists(prefix+'_'+i.to_s+'_domain_'+n.to_s)
              domain = lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s)
              domain = domain.strip.downcase

              # do we found the right domain
              if domain == wlsDomain

                # check jdbc datasources
                if type == 'jdbc'
                    jdbc =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jdbc')
                    unless jdbc == "empty"
                      if jdbc.include? wlsObject
                        return true
                      end
                    end

                elsif type == 'cluster'
                    clusters =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_clusters')
                    unless clusters == "empty"
                      if clusters.include? wlsObject
                        return true
                      end
                    end

                elsif type == 'server'
                    servers =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_servers')
                    unless servers == "empty"
                      if servers.include? wlsObject
                        return true
                      end
                    end

                elsif type == 'machine'
                    machines =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_machines')
                    unless machines == "empty"
                      if machines.include? wlsObject
                        return true
                      end
                    end

                elsif type == 'server_templates'
                    server_templates =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_server_templates')
                    unless server_templates == "empty"
                      if server_templates.include? wlsObject
                        return true
                      end
                    end

                elsif type == 'coherence'
                    coherence_cluster =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_coherence_clusters')
                    unless coherence_cluster == "empty"
                      if coherence_cluster.include? wlsObject
                        return true
                      end
                    end
                elsif type == 'resource'

                  adapter = wlsObject.downcase
                  plan = subType.downcase

                    planValue =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_eis_'+adapter+'_plan')
                    unless planValue == "empty"
                      if planValue.strip.downcase == plan
                        return true
                      end
                    end
                elsif type == 'resource_entry'
                  # ora_mdw_0_domain_0_eis_dbadapter_entries  eis/DB/initial;eis/DB/hr;
                  # ora_mdw_0_domain_0_eis_dbadapter_plan     /opt/oracle/wls/Middleware11gR1/Oracle_SOA1/soa/connectors/Plan_DB.xml
                  # artifact_exists($domain ,"resource_entry",'DbAdapter','eis/DB/hr' )
                  # adapterName          => 'DbAdapter' ,
                  # adapterPath          => "${osMdwHome}/Oracle_SOA1/soa/connectors/DbAdapter.rar",
                  # adapterPlanDir       => "${osMdwHome}/Oracle_SOA1/soa/connectors" ,
                  # adapterPlan          => 'Plan_DB.xml' ,
                  # adapterEntry         => 'eis/DB/hr',

                  adapter = wlsObject.downcase
                  entry = subType.strip

                    planEntries = lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_eis_'+adapter+'_entries')
                    unless planEntries == "empty"
                      if planEntries.include? entry
                        return true
                      end
                    end
                elsif type == 'deployments'
                    deployments =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_deployments')
                    unless deployments == "empty"
                      if deployments.include? wlsObject
                        return true
                      end
                    end
                elsif type == 'filestore'
                    filestores =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_filestores')
                    unless filestores == "empty"
                      if filestores.include? wlsObject
                        return true
                      end
                    end
                elsif type == 'jdbcstore'
                    jdbcstores =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jdbcstores')
                    unless jdbcstores  == "empty"
                      if jdbcstores.include? wlsObject
                        return true
                      end
                    end
                elsif type == 'safagent'
                    safagents =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_safagents')
                    unless safagents  == "empty"
                      if safagents.include? wlsObject
                        return true
                      end
                    end
                elsif type == 'jmsserver'
                    jmsservers =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsservers')
                    unless jmsservers  == "empty"
                      if jmsservers.include? wlsObject
                        return true
                      end
                    end
                elsif type == 'jmsmodule'
                    jmsmodules =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodules')
                    unless jmsmodules  == "empty"
                      if jmsmodules.include? wlsObject
                        return true
                      end
                    end

                elsif type == 'jmsobject'
                  #puts 'jmsobject'
                  if wlsVarExists(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    jms_count = lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    #puts 'jmsobject count: ' + jms_count

                    unless jms_count == "empty"
                      #puts 'jmsobject count found'

                      l = 0
                      while ( l < jms_count.to_i )
                        #puts 'jmsobject counter: ' + l.to_s

                        jmsobjects = lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_objects')
                        #puts 'jmsobject' + jmsobjects

                        unless jmsobjects == "empty"
                          if jmsobjects.include? wlsObject
                            return true
                          end
                        end
                        l += 1
                      end
                    end
                  end

                elsif type == 'jmssubdeployment'
                  #puts 'jmssubdeployment'
                  # this is more complex, this object can exist with this name in multiple jmsmodules
                  if wlsVarExists(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    jms_count =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    unless jms_count == "empty"

                      l = 0
                      while ( l < jms_count.to_i )
                        jmssubobjects =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_subdeployments')
                        jmsmodule     =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_name')
                        # example "JMSModule1/sub-nonpersistent"
                        first = "^[^/]+"
                        last  = "[^/]+$"
                        subNameString  = wlsObject.match last
                        moduleString   = wlsObject.match first

                        #puts "trying to find " + subNameString[0] + " for module " + moduleString[0] + " and " +jmsmodule+" with input " + wlsObject
                        if moduleString[0] == jmsmodule
                          unless jmssubobjects.nil?
                            if jmssubobjects.include? subNameString[0]
                              # puts "return quota found "
                              return true
                            end
                          end
                        end

                        l += 1
                      end

                    end
                  end

                elsif type == 'jmsquota'
                  #puts 'jmsquota'
                  # this is more complex, this object can exist with this name in multiple jmsmodules
                  if wlsVarExists(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    jms_count =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    unless jms_count == "empty"
                      l = 0
                      while ( l < jms_count.to_i )
                        jmssubobjects =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_quotas')
                        jmsmodule     =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_name')
                        # example "JMSModule1/Quota-S"
                        first = "^[^/]+"
                        last  = "[^/]+$"
                        quotaString  = wlsObject.match last
                        moduleString = wlsObject.match first

                        # puts "trying to find " + quotaString[0] + " for module " + moduleString[0] + " and " +jmsmodule+" with input " + wlsObject
                        if moduleString[0] == jmsmodule
                          unless jmssubobjects.nil?
                            if jmssubobjects.include? quotaString[0]
                              # puts "return quota found "
                              return true
                            end
                          end
                        end
                        l += 1
                      end

                    end
                  end

                elsif type == 'foreignserver'
                  #puts 'jmsquota'
                  # this is more complex, this object can exist with this name in multiple jmsmodules
                  if wlsVarExists(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    jms_count =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    unless jms_count == "empty"
                      l = 0
                      while ( l < jms_count.to_i )
                        jmssubobjects =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_foreign_servers')
                        jmsmodule     =  lookupWlsVar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_name')
                        # example "JMSModule1/ForeignServer"
                        first = "^[^/]+"
                        last  = "[^/]+$"
                        foreignServerString  = wlsObject.match last
                        moduleString         = wlsObject.match first

                        # puts "trying to find " + foreignServerString[0] + " for module " + moduleString[0] + " and " +jmsmodule+" with input " + wlsObject
                        if moduleString[0] == jmsmodule
                          unless jmssubobjects.nil?
                            if jmssubobjects.include? foreignServerString[0]
                              # puts "return foreign server found "
                              return true
                            end
                          end
                        end
                        l += 1
                      end

                    end
                  end

                end # if type
              end  # domain_path equal
            end # domain not nil
            n += 1

          end  # while domain

        end
        i += 1
      end # while mdw

    end # mdw count

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
