# restart the puppetmaster when changed
module Puppet
  module Parser
    module Functions
      newfunction(:artifact_exists, :type => :rvalue) do |args|


        if args[0].nil?
          return false
        else
          fullDomainPath = args[0].strip.downcase
        end

        if args[1].nil?
          return false
        else
          type = args[1].strip.downcase
        end

        if args[2].nil?
          return false
        else
          wlsObject = args[2].strip
        end

        if type == 'resource' || type == 'resource_entry'
          if args[3].nil?
            return false
          else
            subType = args[3].strip
          end
        end

        prefix = 'ora_mdw_domain'

        # check the middleware home
        domain_count = lookup_wls_var(prefix + '_cnt')
        if domain_count == 'empty'
          return false
        else
          n = 0
          while n < domain_count.to_i

            # lookup up domain
            domain = lookup_wls_var(prefix + '_' + n.to_s)
            unless domain == 'empty'
              domain = domain.strip.downcase
              # do we found the right domain
              if domain == fullDomainPath

                case type
                when 'jdbc'
                  jdbc =  lookup_wls_var(prefix + '_' + n.to_s + '_jdbc')
                  unless jdbc == 'empty'
                    return true if jdbc.include? wlsObject
                  end

                when 'cluster'
                  clusters =  lookup_wls_var(prefix + '_' + n.to_s + '_clusters')
                  unless clusters == 'empty'
                    return true if clusters.include? wlsObject
                  end

                when 'server'
                  servers =  lookup_wls_var(prefix + '_' + n.to_s + '_servers')
                  unless servers == 'empty'
                    return true if servers.include? wlsObject
                  end

                when 'machine'
                  machines =  lookup_wls_var(prefix + '_' + n.to_s + '_machines')
                  unless machines == 'empty'
                    return true if machines.include? wlsObject
                  end

                when type == 'server_templates'
                  server_templates =  lookup_wls_var(prefix + '_' + n.to_s + '_server_templates')
                  unless server_templates == 'empty'
                    return true if server_templates.include? wlsObject
                  end

                when type == 'coherence'
                  coherence_cluster =  lookup_wls_var(prefix + '_' + n.to_s + '_coherence_clusters')
                  unless coherence_cluster == 'empty'
                    return true if coherence_cluster.include? wlsObject
                  end

                when 'resource'
                  adapter = wlsObject.downcase
                  plan = subType.downcase

                  planValue =  lookup_wls_var(prefix + '_' + n.to_s + '_eis_' + adapter + '_plan')
                  unless planValue == 'empty'
                    return true if planValue.strip.downcase == plan
                  end

                when 'resource_entry'
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

                  planEntries = lookup_wls_var(prefix + '_' + n.to_s + '_eis_' + adapter + '_entries')
                  unless planEntries == 'empty'
                    return true if planEntries.include? entry
                  end

                when 'deployments'
                  deployments =  lookup_wls_var(prefix + '_' + n.to_s + '_deployments')
                  unless deployments == 'empty'
                    return true if deployments.include? wlsObject
                  end
                when 'filestore'
                  filestores =  lookup_wls_var(prefix + '_' + n.to_s + '_filestores')
                  unless filestores == 'empty'
                    return true if filestores.include? wlsObject
                  end
                when 'jdbcstore'
                  jdbcstores =  lookup_wls_var(prefix + '_' + n.to_s + '_jdbcstores')
                  unless jdbcstores  == 'empty'
                    return true if jdbcstores.include? wlsObject
                  end
                when 'safagent'
                  safagents =  lookup_wls_var(prefix + '_' + n.to_s + '_safagents')
                  unless safagents  == 'empty'
                    return true if safagents.include? wlsObject
                  end
                when 'jmsserver'
                  jmsservers =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsservers')
                  unless jmsservers  == 'empty'
                    return true if jmsservers.include? wlsObject
                  end
                when 'jmsmodule'
                  jmsmodules =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodules')
                  unless jmsmodules  == 'empty'
                    return true if jmsmodules.include? wlsObject + ';'
                  end

                when 'jmsobject'
                  # puts 'jmsobject'
                  if wlsVarExists(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    jms_count = lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    # puts 'jmsobject count: ' + jms_count

                    unless jms_count == 'empty'
                      # puts 'jmsobject count found'

                      l = 0
                      while l < jms_count.to_i
                        # puts 'jmsobject counter: ' + l.to_s

                        jmsobjects = lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_' + l.to_s + '_objects')
                        # puts 'jmsobject' + jmsobjects

                        unless jmsobjects == 'empty'
                          return true if jmsobjects.include? wlsObject
                        end
                        l += 1
                      end
                    end
                  end

                when 'jmssubdeployment'
                  # puts 'jmssubdeployment'
                  # this is more complex, this object can exist with this name in multiple jmsmodules
                  if wlsVarExists(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    jms_count =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    unless jms_count == 'empty'

                      l = 0
                      while l < jms_count.to_i
                        jmsSubObjects =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_' + l.to_s + '_subdeployments')
                        jmsModule     =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_' + l.to_s + '_name')
                        # example "JMSModule1/sub-nonpersistent"
                        first = '^[^/]+'
                        last  = '[^/]+$'
                        subNameString  = wlsObject.match last
                        moduleString   = wlsObject.match first

                        # puts "trying to find " + subNameString[0] + " for module " + moduleString[0] + " and " +jmsModule+" with input " + wlsObject
                        if moduleString[0] == jmsModule
                          unless jmsSubObjects == 'empty'
                            if jmsSubObjects.include? subNameString[0]
                              # puts "return quota found "
                              return true
                            end
                          end
                        end

                        l += 1
                      end

                    end
                  end

                when 'jmsquota'
                  # puts 'jmsquota'
                  # this is more complex, this object can exist with this name in multiple jmsmodules
                  if wlsVarExists(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    jms_count =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    unless jms_count == 'empty'
                      l = 0
                      while l < jms_count.to_i
                        jmsQuotaObjects =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_' + l.to_s + '_quotas')
                        jmsModule       =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_' + l.to_s + '_name')
                        # example "JMSModule1/Quota-S"
                        first = '^[^/]+'
                        last  = '[^/]+$'
                        quotaString  = wlsObject.match last
                        moduleString = wlsObject.match first

                        # puts "trying to find " + quotaString[0] + " for module " + moduleString[0] + " and " +jmsModule+" with input " + wlsObject
                        if moduleString[0] == jmsModule
                          unless jmsQuotaObjects == 'empty'
                            if jmsQuotaObjects.include? quotaString[0]
                              # puts "return quota found "
                              return true
                            end
                          end
                        end
                        l += 1
                      end

                    end
                  end

                when 'foreignserver'
                  # puts 'foreignserver'
                  # this is more complex, this object can exist with this name in multiple jmsmodules
                  if wlsVarExists(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    jms_count =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    unless jms_count == 'empty'
                      l = 0
                      while l < jms_count.to_i
                        jmsFsObjects  =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_' + l.to_s + '_foreign_servers')
                        jmsModule     =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_' + l.to_s + '_name')
                        # example "JMSModule1/ForeignServer"
                        first = '^[^/]+'
                        last  = '[^/]+$'
                        foreignServerString  = wlsObject.match last
                        moduleString         = wlsObject.match first

                        # puts "trying to find " + foreignServerString[0] + " for module " + moduleString[0] + " and " +jmsModule+" with input " + wlsObject
                        if moduleString[0] == jmsModule
                          unless jmsFsObjects == 'empty'
                            if jmsFsObjects.include? foreignServerString[0]
                              # puts "return foreign server found "
                              return true
                            end
                          end
                        end
                        l += 1
                      end

                    end
                  end

                when 'foreignserver_object'
                  # puts 'foreignserver_object'
                  # this is more complex, this object can exist with this name in multiple jmsmodules
                  if wlsVarExists(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    jms_count =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_cnt')
                    unless jms_count == 'empty'
                      l = 0
                      while l < jms_count.to_i
                        objects = wlsObject.split('/')
                        # puts "CF entries: " + objects[0] + "-" + objects[1] + "-" + objects[2]
                        # example "jmsClusterModule/ForeignServer/TestQueue"
                        foreignServerObjectString  = objects[2]
                        # facts are in lowercase
                        foreignServerString        = objects[1].downcase
                        moduleString               = objects[0]
                        # puts "lookup " + prefix + '_' + n.to_s + '_jmsmodule_'+l.to_s+'_foreign_server_'+foreignServerString+'_objects'
                        jmsFsEntriesObjects =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_' + l.to_s + '_foreign_server_' + foreignServerString + '_objects')
                        jmsModule           =  lookup_wls_var(prefix + '_' + n.to_s + '_jmsmodule_' + l.to_s + '_name')
                        # puts "found: " + jmsFsEntriesObjects
                        # puts "trying to find " + foreignServerString + " for module " + moduleString + " and " +jmsModule+" with input " + wlsObject
                        if moduleString == jmsModule
                          unless jmsFsEntriesObjects == 'empty'
                            if jmsFsEntriesObjects.include? foreignServerObjectString
                              # puts "return foreign server entry found "
                              return true
                            end
                          end
                        end
                        l += 1
                      end

                    end
                  end

                end # if type

              end
            end
            n += 1
          end
        end

        return false
      end
    end
  end
end

def lookup_wls_var(name)
  if wls_var_exists(name)
    return lookupvar(name).to_s
  end
  'empty'
end

def wls_var_exists(name)
  if lookupvar(name) != :undefined
    if lookupvar(name).nil?
      return false
    end
    return true
  end
  false
end
