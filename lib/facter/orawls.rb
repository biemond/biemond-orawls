# orawls.rb
require 'rexml/document' 
require 'facter'


# read middleware home in the oracle home folder
def get_homes()

  os = Facter.value(:kernel)
  weblogicUser = "oracle"

  if ["Linux"].include?os
    beafile = "/home/"+weblogicUser+"/bea/beahomelist"
  else
    return nil 
  end

  if FileTest.exists?(beafile)
    output = File.read(beafile)
    if output.nil?
      return nil
    else  
      return output.split(/;/)
    end
  else
    return nil
  end

end

def get_bsu_patches(name)
  os = Facter.value(:kernel)

  if ["Linux"].include?os
   if FileTest.exists?(name+'/utils/bsu/patch-client.jar')
    output2 = Facter::Util::Resolution.exec("su -l oracle -c \"java -Xms256m -Xmx512m -jar "+ name+"/utils/bsu/patch-client.jar -report -bea_home="+name+" -output_format=xml\"")
    if output2.nil?
      return "empty"
    end
   else
    return nil
   end 
  else
    return nil 
  end
  doc = REXML::Document.new output2

  root = doc.root
  patches = ""
  root.elements.each("//patchDesc") do |patch|
    patches += patch.elements['patchId'].text + ";"
  end
  return patches

end


def get_opatch_patches(name)

    os = Facter.value(:kernel)
    weblogicUser = "oracle"

    if ["Linux"].include?os
      output3 = Facter::Util::Resolution.exec("su -l "+weblogicUser+" -c \""+name+"/OPatch/opatch lsinventory -patch_id -oh "+name+" -invPtrLoc /etc/oraInst.loc\"")
    end

    opatches = "Patches;"
    if output3.nil?
      opatches = "Error;"
    else 
      output3.each_line do |li|
        opatches += li[5, li.index(':')-5 ].strip + ";" if (li['Patch'] and li[': applied on'] )
      end
    end
   
    return opatches
end  

def get_middleware_1212_Home(name)

    elements = [] 
    name.split(/;/).each_with_index{ |element, index|  
      if FileTest.exists?(element+"/wlserver")
        elements.push(element)
      end
    } 
    return elements
end  


def get_orainst_loc()
  os = Facter.value(:kernel)
  if ["Linux"].include?os
    if FileTest.exists?("/etc/oraInst.loc")
      str = ""
      output = File.read("/etc/oraInst.loc")
      output.split(/\r?\n/).each do |item|
        if item.match(/^inventory_loc/)
          str = item[14,50]
        end
      end
      return str
    else
      return "NotFound"
    end
  end
end

def get_orainst_products(path)
  unless path.nil?
    if FileTest.exists?(path+"/ContentsXML/inventory.xml")
      file = File.read( path+"/ContentsXML/inventory.xml" )
      doc = REXML::Document.new file
      software =  ""
      doc.elements.each("/INVENTORY/HOME_LIST/HOME") do |element|
        str = element.attributes["LOC"]
        unless str.nil? 
          software += str + ";"
          if str.include? "plugins"
            #skip EM agent
          elsif str.include? "agent"
            #skip EM agent 
          elsif str.include? "OraPlaceHolderDummyHome"
            #skip EM agent
          else
            home = str.gsub("/","_").gsub("\\","_").gsub("c:","_c").gsub("d:","_d").gsub("e:","_e")
            output = get_opatch_patches(str)
            Facter.add("ora_inst_patches#{home}") do
              setcode do
                output
              end
            end
          end
        end    
      end
      return software
    else
      return "NotFound"
    end
  else
    return "NotFound" 
  end
end



# read weblogic domains in the user_projects folder of the middleware home
def get_domain(name,i,wlsversion)

  if wlsversion == "1212"
    versionStr = "_1212"
  else
    versionStr = ""   
  end
  
  prefix = "ora_mdw#{versionStr}_#{i}"
  
  os = Facter.value(:kernel)

  if ["Linux"].include?os

    if FileTest.exists?(name+'/user_projects/domains')
      output2 = Facter::Util::Resolution.exec('/bin/ls '+name+'/user_projects/domains')
      if output2.nil?
        Facter.add("#{prefix}_domain_cnt") do
          setcode do
            0
          end
        end
        return nil
      end
    else
      Facter.add("#{prefix}_domain_cnt") do
        setcode do
          0
        end
      end
      return nil
    end

  else
    return nil 
  end

  l = 0

  output2.split(/\r?\n/).each_with_index do |domain, n|

    if ["Linux"].include?os
      domainfile = name+'/user_projects/domains/'+domain+'/config/config.xml'

    end

    if FileTest.exists?(domainfile)

      file = File.read( domainfile)
      doc = REXML::Document.new file
      root = doc.root

      Facter.add("#{prefix}_domain_#{n}") do
        setcode do
          root.elements['name'].text
        end
      end

          
      file = File.read( domainfile)
      doc = REXML::Document.new file
      root = doc.root

      Facter.add("#{prefix}_domain_#{n}") do
        setcode do
          root.elements['name'].text
        end
      end


      k = 0
      root.elements.each("server") do |server| 
        Facter.add("#{prefix}_domain_#{n}_server_#{k}") do
         setcode do
            server.elements['name'].text
          end
        end
        
        port = server.elements['listen-port']
        unless port.nil?
          Facter.add("#{prefix}_domain_#{n}_server_#{k}_port") do
            setcode do
               port.text
            end
          end
        end
        machine = server.elements['machine']
        unless machine.nil?
          Facter.add("#{prefix}_domain_#{n}_server_#{k}_machine") do
            setcode do
               machine.text 
            end
          end
        end
        k += 1            
      end

      servers = ""
      root.elements.each("server") do |svr|
        servers += svr.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_servers") do
         setcode do
           servers
         end
      end

      machines = ""
      root.elements.each("machine") do |mch|
        machines += mch.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_machines") do
         setcode do
           machines
         end
      end
      
      
      server_templates = ""
      root.elements.each("server-template") do |svr_template|
        server_templates += svr_template.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_server_templates") do
         setcode do
           server_templates
         end
      end

      clusters = ""
      root.elements.each("cluster") do |cluster|
        clusters += cluster.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_clusters") do
         setcode do
           clusters
         end
      end

      coherence_clusters = ""
      root.elements.each("coherence-cluster-system-resource") do |coherence|
        coherence_clusters += coherence.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_coherence_clusters") do
         setcode do
           coherence_clusters
         end
      end
            
      deployments = ""
      root.elements.each("app-deployment[module-type = 'ear']") do |apps|
        deployments += apps.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_deployments") do
         setcode do
            deployments
         end
      end

      fileAdapterPlan = ""
      fileAdapterPlanEntries = ""
      root.elements.each("app-deployment[name = 'FileAdapter']") do |apps|
        unless apps.elements['plan-dir'].nil?
          fileAdapterPlan += apps.elements['plan-dir'].text + "/" + apps.elements['plan-path'].text
          subfile = File.read( fileAdapterPlan )
          subdoc = REXML::Document.new subfile

          planroot = subdoc.root
          planroot.elements["variable-definition"].elements.each("variable") do |eis| 
            entry = eis.elements["value"].text 
            if entry.include? "eis"
              fileAdapterPlanEntries +=  eis.elements["value"].text + ";"
            end  
          end

        end   
      end

      Facter.add("#{prefix}_domain_#{n}_eis_fileadapter_plan") do
         setcode do
            fileAdapterPlan
         end
      end

      Facter.add("#{prefix}_domain_#{n}_eis_fileadapter_entries") do
         setcode do
            fileAdapterPlanEntries
         end
      end


      dbAdapterPlan = ""
      dbAdapterPlanEntries = ""
      root.elements.each("app-deployment[name = 'DbAdapter']") do |apps|
        unless apps.elements['plan-dir'].nil?
          dbAdapterPlan += apps.elements['plan-dir'].text + "/" + apps.elements['plan-path'].text 

          subfile = File.read( dbAdapterPlan )
          subdoc = REXML::Document.new subfile

          planroot = subdoc.root
          planroot.elements["variable-definition"].elements.each("variable") do |eis| 
            entry = eis.elements["value"].text 
            if entry.include? "eis"
              dbAdapterPlanEntries +=  eis.elements["value"].text + ";"
            end  
          end


        end
      end

      Facter.add("#{prefix}_domain_#{n}_eis_dbadapter_plan") do
         setcode do
            dbAdapterPlan
         end
      end

      Facter.add("#{prefix}_domain_#{n}_eis_dbadapter_entries") do
         setcode do
            dbAdapterPlanEntries
         end
      end



      aqAdapterPlan = ""
      aqAdapterPlanEntries = ""
      root.elements.each("app-deployment[name = 'AqAdapter']") do |apps|
        unless apps.elements['plan-dir'].nil?
          aqAdapterPlan = apps.elements['plan-dir'].text + "/" + apps.elements['plan-path'].text 

          subfile = File.read( aqAdapterPlan )
          subdoc = REXML::Document.new subfile

          planroot = subdoc.root
          planroot.elements["variable-definition"].elements.each("variable") do |eis| 
            entry = eis.elements["value"].text 
            if entry.include? "eis"
              aqAdapterPlanEntries +=  eis.elements["value"].text + ";"
            end  
          end
        end
      end

      Facter.add("#{prefix}_domain_#{n}_eis_aqadapter_plan") do
         setcode do
            aqAdapterPlan
         end
      end

      Facter.add("#{prefix}_domain_#{n}_eis_aqadapter_entries") do
         setcode do
            aqAdapterPlanEntries
         end
      end


      jmsAdapterPlan = ""
      jmsAdapterPlanEntries = ""
      root.elements.each("app-deployment[name = 'JmsAdapter']") do |apps|
        unless apps.elements['plan-dir'].nil?
          jmsAdapterPlan += apps.elements['plan-dir'].text + "/" + apps.elements['plan-path'].text 

          subfile = File.read( jmsAdapterPlan )
          subdoc = REXML::Document.new subfile

          planroot = subdoc.root
          planroot.elements["variable-definition"].elements.each("variable") do |eis| 
            entry = eis.elements["value"].text 
            if entry.include? "eis"
              jmsAdapterPlanEntries +=  eis.elements["value"].text + ";"
            end  
          end

        end
      end

      Facter.add("#{prefix}_domain_#{n}_eis_jmsadapter_plan") do
         setcode do
            jmsAdapterPlan
         end
      end

      Facter.add("#{prefix}_domain_#{n}_eis_jmsadapter_entries") do
         setcode do
            jmsAdapterPlanEntries
         end
      end



      ftpAdapterPlan = ""
      ftpAdapterPlanEntries = ""
      root.elements.each("app-deployment[name = 'FtpAdapter']") do |apps|
        unless apps.elements['plan-dir'].nil?
          ftpAdapterPlan += apps.elements['plan-dir'].text + "/" + apps.elements['plan-path'].text 

          subfile = File.read( ftpAdapterPlan )
          subdoc = REXML::Document.new subfile

          planroot = subdoc.root
          planroot.elements["variable-definition"].elements.each("variable") do |eis| 
            entry = eis.elements["value"].text 
            if entry.include? "eis"
              ftpAdapterPlanEntries +=  eis.elements["value"].text + ";"
            end  
          end


        end
      end

      Facter.add("#{prefix}_domain_#{n}_eis_ftpadapter_plan") do
         setcode do
            ftpAdapterPlan
         end
      end

      Facter.add("#{prefix}_domain_#{n}_eis_ftpadapter_entries") do
         setcode do
            ftpAdapterPlanEntries
         end
      end



      libraries = ""
      root.elements.each("library") do |libs|
        libraries += libs.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_libraries") do
         setcode do
            libraries
         end
      end

      filestores = ""
      root.elements.each("file-store") do |file|
        filestores += file.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_filestores") do
         setcode do
            filestores
         end
      end

      jdbcstores = ""
      root.elements.each("jdbc-store") do |jdbc|
        jdbcstores += jdbc.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_jdbcstores") do
         setcode do
            jdbcstores
         end
      end

      safagents = ""
      root.elements.each("jdbc-store") do |agent|
        safagents += agent.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_safagents") do
         setcode do
            safagents
         end
      end

      jmsserversstr = ""
      root.elements.each("jms-server") do |jmsservers| 
        jmsserversstr += jmsservers.elements['name'].text + ";"
      end

      Facter.add("#{prefix}_domain_#{n}_jmsservers") do
        setcode do
          jmsserversstr
         end
      end

      k = 0
      jmsmodulestr = "" 
      root.elements.each("jms-system-resource") do |jmsresource|
        jmsstr = "" 
        jmssubdeployments = ""
        jmsmodulestr += jmsresource.elements['name'].text + ";"

        jmsresource.elements.each("sub-deployment") do |sub| 
          jmssubdeployments +=  sub.elements['name'].text + ";"
        end

        Facter.add("#{prefix}_domain_#{n}_jmsmodule_#{k}_subdeployments") do
          setcode do
            jmssubdeployments
          end
        end



        subfile = File.read( name+'/user_projects/domains/'+domain+"/config/" + jmsresource.elements['descriptor-file-name'].text )
        subdoc = REXML::Document.new subfile

        jmsroot = subdoc.root

        jmsmoduleQuotaStr = "" 
        jmsroot.elements.each("quota") do |qu| 
          jmsmoduleQuotaStr +=  qu.attributes["name"] + ";"
        end

        Facter.add("#{prefix}_domain_#{n}_jmsmodule_#{k}_quotas") do
          setcode do
            jmsmoduleQuotaStr
          end
        end


        jmsroot.elements.each("connection-factory") do |cfs| 
          jmsstr +=  cfs.attributes["name"] + ";"
        end

        jmsroot.elements.each("queue") do |queues| 
          jmsstr +=  queues.attributes["name"] + ";"
        end
        jmsroot.elements.each("uniform-distributed-queue") do |dist_queues| 
          jmsstr +=  dist_queues.attributes["name"] + ";"
        end
        
        jmsroot.elements.each("topic") do |topics| 
          jmsstr +=  topics.attributes["name"] + ";"
        end
        jmsroot.elements.each("uniform-distributed-topic") do |dist_topics| 
          jmsstr +=  dist_topics.attributes["name"] + ";"
        end

        
        Facter.add("#{prefix}_domain_#{n}_jmsmodule_#{k}_name") do
          setcode do
            jmsresource.elements['name'].text
          end
        end

        Facter.add("#{prefix}_domain_#{n}_jmsmodule_#{k}_objects") do
          setcode do
            jmsstr
          end
        end
        k += 1
      end
      Facter.add("#{prefix}_domain_#{n}_jmsmodules") do
        setcode do
          jmsmodulestr
        end
      end
      Facter.add("#{prefix}_domain_#{n}_jmsmodule_cnt") do
        setcode do
          k
        end
      end

      jdbcstr = ""
      root.elements.each("jdbc-system-resource") do |jdbcresource| 
        jdbcstr += jdbcresource.elements['name'].text + ";" 
      end

      Facter.add("#{prefix}_domain_#{n}_jdbc") do
        setcode do
          jdbcstr
        end
      end


      l += 1
    end

  end 

  Facter.add("#{prefix}_domain_cnt") do
    setcode do
      l
    end
  end
 
end



mdw11gHomes = get_homes
inventory   = get_orainst_loc
inventory2  = get_orainst_products(inventory)
mdw12gHomes = get_middleware_1212_Home(inventory2)

# report all oracle homes / domains
unless mdw11gHomes.nil?
  mdw11gHomes.each_with_index do |mdw, i|
    Facter.add("ora_mdw_#{i}") do
      setcode do
        mdw
      end
    end
    get_domain(mdw, i,"1111")
  end 
end


# all homes on 1 row
unless mdw11gHomes.nil?
  str = ""
  mdw11gHomes.each do |item|
    str += item + ";"
  end 
  Facter.add("ora_mdw_homes") do
    setcode do
      str
    end
  end 
end

# all homes on 1 row
unless mdw12gHomes.nil?
  str = ""
  mdw12gHomes.each do |item|
    str += item + ";"
  end 
  Facter.add("ora_mdw_1212_homes") do
    setcode do
      str
    end
  end 
end

# report all oracle homes / domains
unless mdw12gHomes.nil?
  mdw12gHomes.each_with_index do |mdw, i|
    Facter.add("ora_mdw_1212_#{i}") do
      setcode do
        mdw
      end
    end
    get_domain(mdw, i,"1212")
  end 
end


# get bsu patches
unless mdw11gHomes.nil?
  mdw11gHomes.each_with_index do |mdw, i|
     Facter.add("ora_mdw_#{i}_bsu") do
       setcode do
        get_bsu_patches(mdw)
       end
     end
  end 
end


# all home counter
Facter.add("ora_mdw_cnt") do
  count = 0
  unless mdw11gHomes.nil?
    count = mdw11gHomes.count
  end

  setcode do
    count
  end
end

# all 12c home counter
Facter.add("ora_mdw_1212_cnt") do
  count = 0
  unless mdw12gHomes.nil?
    count = mdw12gHomes.count
  end

  setcode do
    count
  end
end


# get orainst loc data
Facter.add("ora_inst_loc_data") do
  setcode do
    inventory
  end
end

# get orainst products
Facter.add("ora_inst_products") do
  setcode do
    inventory2
  end
end


