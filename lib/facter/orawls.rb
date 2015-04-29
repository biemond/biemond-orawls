# orawls.rb
require 'rexml/document'
require 'facter'
require 'yaml'

def get_weblogic_user
  weblogicUser = Facter.value('override_weblogic_user')
  if weblogicUser.nil?
    Puppet.debug 'orawls.rb weblogic user is oracle'
  else
    Puppet.debug "orawls.rb weblogic user is #{weblogicUser}"
    return weblogicUser
  end
  'oracle'
end

def get_ora_inventory_path
  os = Facter.value(:kernel)
  if 'Linux' == os
    return '/etc'
  elsif 'SunOS' == os
    return '/var/opt/oracle'
  end
  '/etc'
end

def get_user_home_path
  os = Facter.value(:kernel)
  if 'Linux' == os
    return '/home'
  elsif 'SunOS' == os
    return '/export/home'
  end
  '/home'
end

# read middleware home in the oracle home folder
def get_middleware_1036_home
  beafile = get_user_home_path + '/' + get_weblogic_user + '/bea/beahomelist'

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

def get_middleware_1212_home(name)
  elements = []
  name.split(/;/).each_with_index { |element, index|
    elements.push(element) if FileTest.exists?(element + '/wlserver')
  }
  elements
end

def get_orainst_loc
  if FileTest.exists?(get_ora_inventory_path + '/oraInst.loc')
    str = ''
    output = File.read(get_ora_inventory_path + '/oraInst.loc')
    output.split(/\r?\n/).each do |item|
      str = item[14, 50] if item.match(/^inventory_loc/)
    end
    return str
  else
    return 'NotFound'
  end
end

def get_orainst_products(path)
  # puts "get_orainst_products with path: "+path
  unless path.nil?
    if FileTest.exists?(path + '/ContentsXML/inventory.xml')
      file = File.read(path + '/ContentsXML/inventory.xml')
      doc = REXML::Document.new file
      software =  ''
      doc.elements.each('/INVENTORY/HOME_LIST/HOME') do |element|
        str = element.attributes['LOC']
        software += str + ';' unless str.nil?
      end
      return software
    else
      return 'NotFound'
    end
  end
  'NotFound'
end

# read weblogic domain
def get_domain(domain_path, n)
  prefix = 'ora_mdw'
  domainfile = domain_path + '/config/config.xml'

  return if FileTest.exists?(domainfile) == false

  file = File.read(domainfile)
  doc = REXML::Document.new file
  root = doc.root

  Facter.add("#{prefix}_domain_#{n}") do
    setcode do
      domain_path
    end
  end
  Puppet.debug "orawls.rb #{prefix}_domain_#{n} #{domain_path}"

  Facter.add("#{prefix}_domain_#{n}_name") do
    setcode do
      root.elements['name'].text
    end
  end

  file = File.read(domainfile)
  doc = REXML::Document.new file
  root = doc.root

  Facter.add("#{prefix}_domain_#{n}") do
    setcode do
      root.elements['name'].text
    end
  end

  Puppet.debug 'orawls.rb check authentication provider'
  oimconfigured = 'false'
  root.elements.to_a('security-configuration/realm//sec:name').each do |provider|
    # Puppet.debug "orawls.rb check 2 authentication #{provider} "
    if (provider.text == 'OIMAuthenticationProvider')
      Puppet.debug 'orawls.rb oimconfigured is true'
      oimconfigured = 'true'
    end
  end
  Facter.add("#{prefix}_domain_#{n}_oim_configured") do
    setcode do
      oimconfigured
    end
  end

  k = 0
  root.elements.each('server') do |server|
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

  servers = ''
  root.elements.each('server') do |svr|
    servers += svr.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_servers") do
    setcode do
      servers
    end
  end

  machines = ''
  root.elements.each('machine') do |mch|
    machines += mch.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_machines") do
    setcode do
      machines
    end
  end

  server_templates = ''
  root.elements.each('server-template') do |svr_template|
    server_templates += svr_template.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_server_templates") do
    setcode do
      server_templates
    end
  end

  clusters = ''
  root.elements.each('cluster') do |cluster|
    clusters += cluster.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_clusters") do
    setcode do
      clusters
    end
  end

  coherence_clusters = ''
  root.elements.each('coherence-cluster-system-resource') do |coherence|
    coherence_clusters += coherence.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_coherence_clusters") do
    setcode do
      coherence_clusters
    end
  end

  bpmTargets  = nil
  soaTargets  = nil
  osbTargets  = nil

  deployments = ''
  root.elements.each("app-deployment[module-type = 'ear']") do |apps|
    earName = apps.elements['name'].text
    deployments += earName + ';'

    bpmTargets = apps.elements['target'].text if earName == 'BPMComposer'
    soaTargets = apps.elements['target'].text if earName == 'soa-infra'
    osbTargets = apps.elements['target'].text if earName == 'ALSB Routing' || earName == 'Service Bus Routing'
  end

  Facter.add("#{prefix}_domain_#{n}_deployments") do
    setcode do
      deployments
    end
  end

  unless bpmTargets.nil?
    Facter.add("#{prefix}_domain_#{n}_bpm") do
      setcode do
        bpmTargets
      end
    end
    Puppet.debug "orawls.rb #{prefix}_domain_#{n}_bpm #{bpmTargets}"
  else
    Facter.add("#{prefix}_domain_#{n}_bpm") do
      setcode do
        'NotFound'
      end
    end
  end

  unless soaTargets.nil?
    Facter.add("#{prefix}_domain_#{n}_soa") do
      setcode do
        soaTargets
      end
    end
    Puppet.debug "orawls.rb #{prefix}_domain_#{n}_soa #{soaTargets}"
  else
    Facter.add("#{prefix}_domain_#{n}_soa") do
      setcode do
        'NotFound'
      end
    end
  end

  unless osbTargets.nil?
    Facter.add("#{prefix}_domain_#{n}_osb") do
      setcode do
        osbTargets
      end
    end
    Puppet.debug "orawls.rb #{prefix}_domain_#{n}_osb #{osbTargets}"
  else
    Facter.add("#{prefix}_domain_#{n}_osb") do
      setcode do
        'NotFound'
      end
    end
  end

  fileAdapterPlan = ''
  fileAdapterPlanEntries = ''
  root.elements.each("app-deployment[name = 'FileAdapter']") do |apps|
    unless apps.elements['plan-path'].nil?
      unless apps.elements['plan-dir'].attributes['xsi:nil'] == 'true'
        fileAdapterPlan += apps.elements['plan-dir'].text + '/' + apps.elements['plan-path'].text
      else
        fileAdapterPlan += apps.elements['plan-path'].text
      end
      if FileTest.exists?(fileAdapterPlan)
        subfile = File.read(fileAdapterPlan)
        subdoc = REXML::Document.new subfile
        planroot = subdoc.root
        planroot.elements['variable-definition'].elements.each('variable') do |eis|
          entry = eis.elements['value'].text
          fileAdapterPlanEntries +=  eis.elements['value'].text + ';' if entry.include? 'eis'
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

  dbAdapterPlan = ''
  dbAdapterPlanEntries = ''
  root.elements.each("app-deployment[name = 'DbAdapter']") do |apps|
    unless apps.elements['plan-path'].nil?
      unless apps.elements['plan-dir'].attributes['xsi:nil'] == 'true'
        dbAdapterPlan += apps.elements['plan-dir'].text + '/' + apps.elements['plan-path'].text
      else
        dbAdapterPlan += apps.elements['plan-path'].text
      end
      Puppet.debug "db #{dbAdapterPlan}"
      if FileTest.exists?(dbAdapterPlan)

        subfile = File.read(dbAdapterPlan)
        subdoc = REXML::Document.new subfile

        planroot = subdoc.root
        planroot.elements['variable-definition'].elements.each('variable') do |eis|
          entry = eis.elements['value'].text
          if entry.include? 'eis'
            dbAdapterPlanEntries +=  eis.elements['value'].text + ';'
          end
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

  aqAdapterPlan = ''
  aqAdapterPlanEntries = ''
  root.elements.each("app-deployment[name = 'AqAdapter']") do |apps|
    unless apps.elements['plan-path'].nil?
      unless apps.elements['plan-dir'].attributes['xsi:nil'] == 'true'
        aqAdapterPlan += apps.elements['plan-dir'].text + '/' + apps.elements['plan-path'].text
      else
        aqAdapterPlan += apps.elements['plan-path'].text
      end
      if FileTest.exists?(aqAdapterPlan)

        subfile = File.read(aqAdapterPlan)
        subdoc = REXML::Document.new subfile

        planroot = subdoc.root
        planroot.elements['variable-definition'].elements.each('variable') do |eis|
          entry = eis.elements['value'].text
          if entry.include? 'eis'
            aqAdapterPlanEntries +=  eis.elements['value'].text + ';'
          end
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

  jmsAdapterPlan = ''
  jmsAdapterPlanEntries = ''
  root.elements.each("app-deployment[name = 'JmsAdapter']") do |apps|
    unless apps.elements['plan-path'].nil?
      unless apps.elements['plan-dir'].attributes['xsi:nil'] == 'true'
        jmsAdapterPlan += apps.elements['plan-dir'].text + '/' + apps.elements['plan-path'].text
      else
        jmsAdapterPlan += apps.elements['plan-path'].text
      end
      if FileTest.exists?(jmsAdapterPlan)

        subfile = File.read(jmsAdapterPlan)
        subdoc = REXML::Document.new subfile

        planroot = subdoc.root
        planroot.elements['variable-definition'].elements.each('variable') do |eis|
          entry = eis.elements['value'].text
          if entry.include? 'eis'
            jmsAdapterPlanEntries +=  eis.elements['value'].text + ';'
          end
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

  ftpAdapterPlan = ''
  ftpAdapterPlanEntries = ''
  root.elements.each("app-deployment[name = 'FtpAdapter']") do |apps|
    unless apps.elements['plan-path'].nil?
      unless apps.elements['plan-dir'].attributes['xsi:nil'] == 'true'
        ftpAdapterPlan += apps.elements['plan-dir'].text + '/' + apps.elements['plan-path'].text
      else
        ftpAdapterPlan += apps.elements['plan-path'].text
      end
      Puppet.debug "ftp #{ftpAdapterPlan}"
      if FileTest.exists?(ftpAdapterPlan)

        subfile = File.read(ftpAdapterPlan)
        subdoc = REXML::Document.new subfile

        planroot = subdoc.root
        planroot.elements['variable-definition'].elements.each('variable') do |eis|
          entry = eis.elements['value'].text
          if entry.include? 'eis'
            ftpAdapterPlanEntries +=  eis.elements['value'].text + ';'
          end
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

  jrfTargets  = nil
  bamTargets  = nil
  libraries   = ''
  root.elements.each('library') do |libs|
    libName = libs.elements['name'].text
    libraries += libName + ';'
    if libName.include? 'adf.oracle.domain#1.0'
      jrfTargets = libs.elements['target'].text
    end
    if libName.include? 'oracle.bam.library'
      bamTargets = libs.elements['target'].text
    end

  end

  unless jrfTargets.nil?
    Facter.add("#{prefix}_domain_#{n}_jrf") do
      setcode do
        jrfTargets
      end
    end
    Puppet.debug "orawls.rb #{prefix}_domain_#{n}_jrf #{jrfTargets}"
  else
    Facter.add("#{prefix}_domain_#{n}_jrf") do
      setcode do
        'NotFound'
      end
    end
    Puppet.debug "orawls.rb #{prefix}_domain_#{n}_jrf NotFound"
  end

  unless bamTargets.nil?
    Facter.add("#{prefix}_domain_#{n}_bam") do
      setcode do
        bamTargets
      end
    end
    Puppet.debug "orawls.rb #{prefix}_domain_#{n}_bam #{bamTargets}"
  else
    Facter.add("#{prefix}_domain_#{n}_bam") do
      setcode do
        'NotFound'
      end
    end
  end

  Facter.add("#{prefix}_domain_#{n}_libraries") do
    setcode do
      libraries
    end
  end

  filestores = ''
  root.elements.each('file-store') do |filestore|
    filestores += filestore.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_filestores") do
    setcode do
      filestores
    end
  end

  jdbcstores = ''
  root.elements.each('jdbc-store') do |jdbc|
    jdbcstores += jdbc.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_jdbcstores") do
    setcode do
      jdbcstores
    end
  end

  safagents = ''
  root.elements.each('saf-agent') do |agent|
    safagents += agent.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_safagents") do
    setcode do
      safagents
    end
  end

  jmsserversstr = ''
  root.elements.each('jms-server') do |jmsservers|
    jmsserversstr += jmsservers.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_jmsservers") do
    setcode do
      jmsserversstr
    end
  end

  k = 0
  jmsmodulestr = ''
  root.elements.each('jms-system-resource') do |jmsresource|
    jmsstr = ''
    jmssubdeployments = ''
    jmsmodulestr += jmsresource.elements['name'].text + ';'

    jmsresource.elements.each('sub-deployment') do |sub|
      jmssubdeployments +=  sub.elements['name'].text + ';'
    end

    Facter.add("#{prefix}_domain_#{n}_jmsmodule_#{k}_subdeployments") do
      setcode do
        jmssubdeployments
      end
    end

    unless jmsresource.elements['descriptor-file-name'].nil?
      fileJms = jmsresource.elements['descriptor-file-name'].text
    else
      fileJms = 'jms/' + jmsresource.elements['name'].text.downcase + '-jms.xml'
    end

    subfile = File.read(domain_path + '/config/' + fileJms)
    subdoc = REXML::Document.new subfile

    jmsroot = subdoc.root

    jmsmoduleQuotaStr = ''
    jmsroot.elements.each('quota') do |qu|
      jmsmoduleQuotaStr +=  qu.attributes['name'] + ';'
    end

    Facter.add("#{prefix}_domain_#{n}_jmsmodule_#{k}_quotas") do
      setcode do
        jmsmoduleQuotaStr
      end
    end

    jmsmoduleForeingServerStr = ''
    jmsroot.elements.each('foreign-server') do |fs|
      fsName = fs.attributes['name']
      jmsmoduleForeingServerStr +=  fsName + ';'

      jmsmoduleForeignServerObjectsStr = ''
      fs.elements.each('foreign-destination') do |cf|
        jmsmoduleForeignServerObjectsStr +=  cf.attributes['name'] + ';'
      end
      fs.elements.each('foreign-connection-factory') do |dest|
        jmsmoduleForeignServerObjectsStr +=  dest.attributes['name'] + ';'
      end

      Facter.add("#{prefix}_domain_#{n}_jmsmodule_#{k}_foreign_server_#{fsName}_objects") do
        setcode do
          jmsmoduleForeignServerObjectsStr
        end
      end

      # puts "#{prefix}_domain_#{n}_jmsmodule_#{k}_foreign_server_#{fsName}_objects"
      # puts "values "+jmsmoduleForeignServerObjectsStr
    end

    Facter.add("#{prefix}_domain_#{n}_jmsmodule_#{k}_foreign_servers") do
      setcode do
        jmsmoduleForeingServerStr
      end
    end
    # puts "#{prefix}_domain_#{n}_jmsmodule_#{k}_foreign_servers"
    # puts "values "+jmsmoduleForeingServerStr

    jmsroot.elements.each('connection-factory') do |cfs|
      jmsstr +=  cfs.attributes['name'] + ';'
    end

    jmsroot.elements.each('queue') do |queues|
      jmsstr +=  queues.attributes['name'] + ';'
    end
    jmsroot.elements.each('uniform-distributed-queue') do |dist_queues|
      jmsstr +=  dist_queues.attributes['name'] + ';'
    end

    jmsroot.elements.each('topic') do |topics|
      jmsstr +=  topics.attributes['name'] + ';'
    end
    jmsroot.elements.each('uniform-distributed-topic') do |dist_topics|
      jmsstr +=  dist_topics.attributes['name'] + ';'
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

  jdbcstr = ''
  root.elements.each('jdbc-system-resource') do |jdbcresource|
    jdbcstr += jdbcresource.elements['name'].text + ';'
  end

  Facter.add("#{prefix}_domain_#{n}_jdbc") do
    setcode do
      jdbcstr
    end
  end
end

oraInstPath   = get_orainst_loc
oraProducts   = get_orainst_products(oraInstPath)

mdw11gHomes   = get_middleware_1036_home
mdw12cHomes   = get_middleware_1212_home(oraProducts)

Puppet.debug "orawls.rb oraInstPath #{oraInstPath}"
Puppet.debug "orawls.rb oraProducts #{oraProducts}"
Puppet.debug "orawls.rb mdw11gHomes #{mdw11gHomes}"
Puppet.debug "orawls.rb mdw12cHomes #{mdw12cHomes}"

# report all oracle homes / domains
count = -1
unless mdw11gHomes.nil?
  mdw11gHomes.each_with_index do |mdw, index|
    count += 1
    Facter.add("ora_mdw_#{count}") do
      setcode do
        mdw
      end
    end
  end
end
unless mdw12cHomes.nil?
  mdw12cHomes.each_with_index do |mdw, index|
    count += 1
    Facter.add("ora_mdw_#{count}") do
      setcode do
        mdw
      end
    end
  end
end

count_domains = -1

def get_domains(domain_folder, count_domains)
  # check all domain in a domains folder
  if FileTest.exists?(domain_folder)
    count_domains += 1
    # add domain facts
    get_domain(domain_folder, count_domains)
    # add a full path domain fact
    Facter.add("ora_mdw_domain_#{count_domains}") do
      setcode do
        domain_folder
      end
    end
  end
  count_domains
end

# read the domains yaml and analyze domain
begin
  entries = YAML.load(File.open('/etc/wls_domains.yaml'))
  unless entries.nil?
    domains = entries['domains']
    unless domains.nil?
      domains.each { |key, values|
        Puppet.debug "found #{key} with path #{values}"
        count_domains = get_domains(values, count_domains)
      }
    end
  end
rescue
  Puppet.debug '/etc/wls_domains.yaml not found'
end

Facter.add('ora_mdw_domain_cnt') do
  setcode do
    count_domains += 1
  end
end

# all homes on 1 row
mdw_home_str = ''
unless mdw11gHomes.nil?
  mdw11gHomes.each do |item|
    mdw_home_str += item + ';'
  end
end
unless mdw12cHomes.nil?
  mdw12cHomes.each do |item|
    mdw_home_str += item + ';'
  end
end
Facter.add('ora_mdw_homes') do
  setcode do
    mdw_home_str
  end
end
Puppet.debug "orawls.rb ora_mdw_homes #{mdw_home_str}"

# all home counter
mdw_count = 0
mdw_count = mdw11gHomes.count unless mdw11gHomes.nil?
mdw_count += mdw12cHomes.count unless mdw12cHomes.nil?

Facter.add('ora_mdw_cnt') do
  setcode do
    mdw_count
  end
end
Puppet.debug "orawls.rb ora_mdw_cnt #{mdw_count}"

# get orainst loc data
Facter.add('ora_inst_loc_data') do
  setcode do
    oraInstPath
  end
end

# get orainst products
Facter.add('ora_inst_products') do
  setcode do
    oraProducts
  end
end
