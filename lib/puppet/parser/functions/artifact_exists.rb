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
        wlsversion = args[4].strip
      end
    else
      if args[3].nil?
        return art_exists
      else
        wlsversion = args[3].strip
      end
    end

    if wlsversion == "1212"
      versionStr = "_1212"
    else
      versionStr = ""
    end

    prefix = "ora_mdw"+versionStr

    # check the middleware home
    mdw_count = lookupvar(prefix+'_cnt')
    if mdw_count.nil?
      return art_exists
    else
      # check the all mdw home
      i = 0
      while ( i < mdw_count.to_i)

        if lookupvar(prefix+'_'+i.to_s) != :undefined
          mdw = lookupvar(prefix+'_'+i.to_s)
          mdw = mdw.strip.downcase

          # how many domains are there in this mdw home
          domain_count = lookupvar(prefix+'_'+i.to_s+'_domain_cnt')
          n = 0
          while ( n < domain_count.to_i )

            # lookup up domain
            if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s) != :undefined
              domain = lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s)
              domain = domain.strip.downcase

              # do we found the right domain
              if domain == wlsDomain

                # check jdbc datasources
                if type == 'jdbc'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jdbc') != :undefined
                    jdbc =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jdbc')
                    unless jdbc.nil?
                      if jdbc.include? wlsObject
                        return true
                      end
                    end
                  end

                elsif type == 'cluster'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_clusters') != :undefined
                    clusters =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_clusters')
                    unless clusters.nil?
                      if clusters.include? wlsObject
                        return true
                      end
                    end
                  end

                elsif type == 'server'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_servers') != :undefined
                    servers =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_servers')
                    unless servers.nil?
                      if servers.include? wlsObject
                        return true
                      end
                    end
                  end

                elsif type == 'machine'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_machines') != :undefined
                    machines =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_machines')
                    unless machines.nil?
                      if machines.include? wlsObject
                        return true
                      end
                    end
                  end

                elsif type == 'server_templates'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_server_templates') != :undefined
                    server_templates =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_server_templates')
                    unless server_templates.nil?
                      if server_templates.include? wlsObject
                        return true
                      end
                    end
                  end

                elsif type == 'coherence'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_coherence_clusters') != :undefined
                    coherence_cluster =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_coherence_clusters')
                    unless coherence_cluster.nil?
                      if coherence_cluster.include? wlsObject
                        return true
                      end
                    end
                  end

                elsif type == 'resource'

                  adapter = wlsObject.downcase
                  plan = subType.downcase

                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_eis_'+adapter+'_plan') != :undefined
                    planValue =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_eis_'+adapter+'_plan')
                    unless planValue.nil?
                      if planValue.strip.downcase == plan
                        return true
                      end
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

                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_eis_'+adapter+'_entries') != :undefined
                    planEntries = lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_eis_'+adapter+'_entries')
                    unless planEntries.nil?
                      if planEntries.include? entry
                        return true
                      end
                    end
                  end
                elsif type == 'deployments'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_deployments') != :undefined
                    deployments =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_deployments')
                    unless deployments.nil?
                      if deployments.include? wlsObject
                        return true
                      end
                    end
                  end
                elsif type == 'filestore'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_filestores') != :undefined
                    filestores =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_filestores')
                    unless filestores.nil?
                      if filestores.include? wlsObject
                        return true
                      end
                    end
                  end
                elsif type == 'jdbcstore'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jdbcstores') != :undefined
                    jdbcstores =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jdbcstores')
                    unless jdbcstores.nil?
                      if jdbcstores.include? wlsObject
                        return true
                      end
                    end
                  end
                elsif type == 'safagent'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_safagents') != :undefined
                    safagents =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_safagents')
                    unless safagents.nil?
                      if safagents.include? wlsObject
                        return true
                      end
                    end
                  end
                elsif type == 'jmsserver'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsservers') != :undefined
                    jmsservers =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsservers')
                    unless jmsservers.nil?
                      if jmsservers.include? wlsObject
                        return true
                      end
                    end
                  end
                elsif type == 'jmsmodule'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodules') != :undefined
                    jmsmodules =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodules')
                    unless jmsmodules.nil?
                      if jmsmodules.include? wlsObject
                        return true
                      end
                    end
                  end

                elsif type == 'jmsobject'

                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt') != :undefined
                    jms_count =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    unless jms_count.nil?

                      l = 0
                      while ( l < jms_count.to_i )
                        jmsobjects =  ""
                        if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_objects') != :undefined
                          jmsobjects =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_objects')
                        end
                        unless jmsobjects.nil?
                          if jmsobjects.include? wlsObject
                            return true
                          end
                        end
                        l += 1
                      end
                    end
                  end

                elsif type == 'jmssubdeployment'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt') != :undefined
                    jms_count =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    unless jms_count.nil?

                      l = 0
                      while ( l < jms_count.to_i )
                        jmssubobjects =  ""
                        jmsmodule     =  ""
                        if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_subdeployments') != :undefined
                          jmssubobjects = lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_subdeployments')
                        end
                        if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_name')  != :undefined
                          jmsmodule     = lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_name')
                        end
                        if wlsObject.include? jmsmodule
                          unless jmssubobjects.nil?
                            pattern = "\/(.*)"
                            #sub_string = ""
                            sub_string =wlsObject.match pattern
                            if jmssubobjects.include? sub_string[1]
                              return true
                            end
                          end
                        end

                        l += 1
                      end

                    end
                  end

                elsif type == 'jmsquota'
                  if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt') != :undefined
                    jms_count2 =  lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_cnt')
                    unless jms_count2.nil?

                      l = 0
                      while ( l < jms_count2.to_i )
                        jmssubobjects2 =  ""
                        jmsmodule2     =  ""
                        if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_quotas') != :undefined
                          jmssubobjects2 = lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_quotas')
                        end
                        if lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_name')  != :undefined
                          jmsmodule2     = lookupvar(prefix+'_'+i.to_s+'_domain_'+n.to_s+'_jmsmodule_'+l.to_s+'_name')
                        end
                        if wlsObject.include? jmsmodule2
                          unless jmssubobjects2.nil?
                            pattern2 = "\/(.*)"
                            #sub_string = ""
                            sub_string2 =wlsObject.match pattern2
                            if jmssubobjects2.include? sub_string2[1]
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

