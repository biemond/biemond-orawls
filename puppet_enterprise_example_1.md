puppet 3.12 enterprise with orawls puppet module
================================================

example of wls 10.3.6 cluster on puppet enterprise 3.12

3 servers 
- adminwls.alfa.local
- nodewls1.alfa.local
- nodewls2.alfa.local


Use the following software located at my puppet middleware share
- jdk-7u51-linux-x64.tar.gz
- wls1036_generic.jar
- p17071663_1036_Generic.zip

create the following facts on every puppet node ( to override the default oracle OS user with wls and also for the domains folder )
- mkdir -p /etc/puppetlabs/facter/facts.d
- cd /etc/puppetlabs/facter/facts.d
- vi wls.txt
    override_weblogic_user=wls
    override_weblogic_domain_folder=/opt/oracle/wlsdomains



common.yaml
-----------

    ---
    messageDefault: 'default'
    
    messageEnv:     'common'
    
    wls_oracle_base_home_dir: &wls_oracle_base_home_dir "/opt/oracle"
    wls_weblogic_user:        &wls_weblogic_user        "weblogic"
    wls_weblogic_home_dir:    &wls_weblogic_home_dir    "/opt/oracle/middleware11g/wlserver_10.3"
    wls_middleware_home_dir:  &wls_middleware_home_dir  "/opt/oracle/middleware11g"
    wls_version:              &wls_version              1036
    
    # global OS vars
    wls_os_user:              &wls_os_user              "wls"
    wls_os_group:             &wls_os_group             "dba"
    wls_download_dir:         &wls_download_dir         "/data/install"
    wls_source:               &wls_source               "puppet:///middleware/"
    wls_jdk_home_dir:         &wls_jdk_home_dir         "/usr/java/jdk1.7.0_51"
    wls_log_dir:              &wls_log_dir              "/data/logs"
    
    
    #WebLogic installation variables 
    orawls::weblogic::version:              *wls_version
    orawls::weblogic::filename:             "wls1036_generic.jar"
    orawls::weblogic::middleware_home_dir:  *wls_middleware_home_dir
    orawls::weblogic::log_output:           false
    
    # hiera default anchors
    orawls::weblogic::jdk_home_dir:         *wls_jdk_home_dir
    orawls::weblogic::oracle_base_home_dir: *wls_oracle_base_home_dir
    orawls::weblogic::os_user:              *wls_os_user
    orawls::weblogic::os_group:             *wls_os_group
    orawls::weblogic::download_dir:         *wls_download_dir
    orawls::weblogic::source:               *wls_source
    orawls::weblogic::remote_file:          true
    
    
    # patches for WebLogic 10.3.6
    bsu_instances:
      'BYJ1':
        patch_id:                "BYJ1"
        patch_file:              "p17071663_1036_Generic.zip"
        log_output:              true
        remote_file:             true
    
    
    # handy WebLogic scripts in /opt/scripts/wls
    orautils::osOracleHomeParam:      *wls_oracle_base_home_dir
    orautils::oraInventoryParam:      "/opt/oracle/oraInventory"
    orautils::osDomainTypeParam:      "admin"
    orautils::osLogFolderParam:       *wls_log_dir
    orautils::osDownloadFolderParam:  *wls_download_dir
    orautils::osMdwHomeParam:         *wls_middleware_home_dir
    orautils::osWlHomeParam:          *wls_weblogic_home_dir
    orautils::oraUserParam:           *wls_os_user
    
    orautils::osDomainParam:          "Wls1036"
    orautils::osDomainPathParam:      "/opt/oracle/wlsdomains/domains/Wls1036"
    orautils::nodeMgrPathParam:       "/opt/oracle/middleware11g/wlserver_10.3/server/bin"
    
    orautils::nodeMgrPortParam:       5556
    orautils::wlsUserParam:           *wls_weblogic_user
    orautils::wlsPasswordParam:       "weblogic1"
    orautils::wlsAdminServerParam:    "AdminServer"
    

adminwls.alfa.local.yaml

    ---
    messageEnv: 'admin'
    
    orawls::weblogic::log_output:   true
    
    logoutput:                     &logoutput                     true
    
    hosts:
      'adminwls.alfa.local':
        ip:                "10.10.10.20"
        host_aliases:      'adminwls'
      'nodewls1.alfa.local':
        ip:                "10.10.10.100"
        host_aliases:      'nodewls1'
      'nodewls2.alfa.local':
        ip:                "10.10.10.200"
        host_aliases:      'nodewls2'
      'localhost':
        ip:                "127.0.0.1"
        host_aliases:      cat 'localhost.localdomain,localhost4,localhost4.localdomain4'
    
    
    # when you have just one domain on a server
    domain_name:                "Wls1036"
    domain_adminserver:         "AdminServer"
    domain_adminserver_address: "10.10.10.20"
    domain_adminserver_port:    7001
    domain_nodemanager_port:    5556
    domain_wls_password:        "weblogic1"
    domain_user_config_file:    "/home/oracle/oracle-Wls1036-WebLogicConfig.properties"
    domain_user_key_file:       "/home/oracle/oracle-Wls1036-WebLogicKey.properties"
    
    # create a standard domain
    domain_instances:
      'wlsDomain':
         domain_template:          "standard"
         development_mode:         false
         log_output:               *logoutput
    
    # pack domains
    pack_domain_instances:
      'wlsDomain':
         log_output:               *logoutput
    
    # create and startup the nodemanager
    nodemanager_instances:
      'nodemanager':
         log_output:           *logoutput
    
    # startup adminserver for extra configuration
    control_instances:
      'startWLSAdminServer':
         domain_dir:           "/opt/oracle/wlsdomains/domains/Wls1036"
         server_type:          'admin'
         target:               'Server'
         server:               'AdminServer'
         action:               'start'
         log_output:           *logoutput
    
    # create password file for WLST utility
    userconfig_instances:
      'Wls12c':
         log_output:           *logoutput
         user_config_dir:      '/home/wls'
    
    # create 2 machines
    machines_instances:
      'createMachine_node1':
         log_output:           *logoutput
         weblogic_type:        "machine"
         weblogic_object_name: "Node1"
         script:               'createMachine.py'
         params:
            - "machineName      = 'Node1'"
            - "machineDnsName   = '10.10.10.100'"
      'createMachine_node2':
         log_output:           *logoutput
         weblogic_type:        "machine"
         weblogic_object_name: "Node2"
         script:               'createMachine.py'
         params:
            - "machineName      = 'Node2'"
            - "machineDnsName   = '10.10.10.200'"
    
    server_instances:
          'wlsServer1_node1':
             weblogic_object_name: "wlsServer1"
             log_output:           *logoutput
             weblogic_type:        "server"
             script:               'createServer.py'
             params:
                - "listenPort       = 8001"
                - "nodeMgrLogDir    = '/data/logs'"
                - "javaArguments    = '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer1.out -Dweblogic.Stderr=/data/logs/wlsServer1_err.out'"
                - "wlsServerName    = 'wlsServer1'"
                - "machineName      = 'Node1'"
                - "listenAddress    = '10.10.10.100'"
          'wlsServer2_node2':
             weblogic_object_name: "wlsServer2"
             log_output:           *logoutput
             weblogic_type:        "server"
             script:               'createServer.py'
             params:
                - "listenPort       = 8001"
                - "nodeMgrLogDir    = '/data/logs'"
                - "javaArguments    = '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer2.out -Dweblogic.Stderr=/data/logs/wlsServer2_err.out'"
                - "wlsServerName    = 'wlsServer2'"
                - "machineName      = 'Node2'"
                - "listenAddress    = '10.10.10.200'"
          'wlsServer3_node1':
             weblogic_object_name: "wlsServer3"
             log_output:           *logoutput
             weblogic_type:        "server"
             script:               'createServer.py'
             params:
                - "listenPort       = 8002"
                - "nodeMgrLogDir    = '/data/logs'"
                - "javaArguments    = '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer1.out -Dweblogic.Stderr=/data/logs/wlsServer1_err.out'"
                - "wlsServerName    = 'wlsServer3'"
                - "machineName      = 'Node1'"
                - "listenAddress    = '10.10.10.100'"
          'wlsServer4_node2':
             weblogic_object_name: "wlsServer4"
             log_output:           *logoutput
             weblogic_type:        "server"
             script:               'createServer.py'
             params:
                - "listenPort       = 8002"
                - "nodeMgrLogDir    = '/data/logs'"
                - "javaArguments    = '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer2.out -Dweblogic.Stderr=/data/logs/wlsServer2_err.out'"
                - "wlsServerName    = 'wlsServer4'"
                - "machineName      = 'Node2'"
                - "listenAddress    = '10.10.10.200'"
    
    cluster_instances:
          'cluster_web':
             weblogic_object_name: "WebCluster"
             log_output:           *logoutput
             weblogic_type:        "cluster"
             script:               'createCluster.py'
             params:
                - "clusterName      = 'WebCluster'"
                - "clusterNodes     = 'wlsServer1,wlsServer2'"
          'cluster_web2':
             weblogic_object_name: "WebCluster2"
             log_output:           *logoutput
             weblogic_type:        "cluster"
             script:               'createCluster.py'
             params:
                - "clusterName      = 'WebCluster2'"
                - "clusterNodes     = 'wlsServer3,wlsServer4'"
    
    
nodewls1.alfa.local.yaml
------------------------

    ---
    messageEnv: 'node1'
    
    orawls::weblogic::log_output:   true
    
    
    logoutput:                     &logoutput                     true
    
    hosts:
      'adminwls.alfa.local':
        ip:                "10.10.10.20"
        host_aliases:      'adminwls'
      'nodewls1.alfa.local':
        ip:                "10.10.10.100"
        host_aliases:      'nodewls1'
      'nodewls2.alfa.local':
        ip:                "10.10.10.200"
        host_aliases:      'nodewls2'
      'localhost':
        ip:                "127.0.0.1"
        host_aliases:      cat 'localhost.localdomain,localhost4,localhost4.localdomain4'
    
    # when you have just one domain on a server
    domain_name:                "Wls1036"
    domain_adminserver:         "AdminServer"
    domain_adminserver_address: "10.10.10.20"
    domain_adminserver_port:    7001
    domain_nodemanager_port:    5556
    domain_wls_password:        "weblogic1"
    domain_user_config_file:    "/home/oracle/oracle-Wls1036-WebLogicConfig.properties"
    domain_user_key_file:       "/home/oracle/oracle-Wls1036-WebLogicKey.properties"
    
    
    # create a standard domain
    domain_instances:
    
    
    # copy domains to other nodes
    copy_instances:
      'wlsDomain':
         log_output:              *logoutput
    
    
    # create and startup the nodemanager
    nodemanager_instances:
      'nodemanager':
         log_output:           *logoutput
    

nodewls2.alfa.local.yaml
------------------------

    ---
    messageEnv: 'node2'
    
    orawls::weblogic::log_output:   true
    
    
    logoutput:                     &logoutput                     true
    
    hosts:
      'adminwls.alfa.local':
        ip:                "10.10.10.20"
        host_aliases:      'adminwls'
      'nodewls1.alfa.local':
        ip:                "10.10.10.100"
        host_aliases:      'nodewls1'
      'nodewls2.alfa.local':
        ip:                "10.10.10.200"
        host_aliases:      'nodewls2'
      'localhost':
        ip:                "127.0.0.1"
        host_aliases:      cat 'localhost.localdomain,localhost4,localhost4.localdomain4'
    
    # when you have just one domain on a server
    domain_name:                "Wls1036"
    domain_adminserver:         "AdminServer"
    domain_adminserver_address: "10.10.10.20"
    domain_adminserver_port:    7001
    domain_nodemanager_port:    5556
    domain_wls_password:        "weblogic1"
    domain_user_config_file:    "/home/oracle/oracle-Wls1036-WebLogicConfig.properties"
    domain_user_key_file:       "/home/oracle/oracle-Wls1036-WebLogicKey.properties"
    
    
    # create a standard domain
    domain_instances:
    
    
    # copy domains to other nodes
    copy_instances:
      'wlsDomain':
         log_output:              *logoutput
    
    
    # create and startup the nodemanager
    nodemanager_instances:
      'nodemanager':
         log_output:           *logoutput
    
    
    
    

wls_admin.pp for the admin node
-------------------------------


    class wls_admin {
      
      include os, ssh, java
      include orawls::weblogic, orautils
      include bsu
      include domains, nodemanager, startwls, userconfig
      include machines
      include managed_servers
      include clusters
      include jms_servers
      include jms_modules
      include pack_domain
    
      Class[java] -> Class[orawls::weblogic]
    }  
    
    # operating settings for Middleware
    class os {
    
      notice "class os ${operatingsystem}"
    
      $default_params = {}
      $host_instances = hiera('hosts', [])
      create_resources('host',$host_instances, $default_params)
    
      exec { "create swap file":
        command => "/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=8192",
        creates => "/var/swap.1",
      }
    
      exec { "attach swap file":
        command => "/sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1",
        require => Exec["create swap file"],
        unless => "/sbin/swapon -s | grep /var/swap.1",
      }
    
      #add swap file entry to fstab
      exec {"add swapfile entry to fstab":
        command => "/bin/echo >>/etc/fstab /var/swap.1 swap swap defaults 0 0",
        require => Exec["attach swap file"],
        user => root,
        unless => "/bin/grep '^/var/swap.1' /etc/fstab 2>/dev/null",
      }
    
      service { iptables:
            enable    => false,
            ensure    => false,
            hasstatus => true,
      }
    
      group { 'dba' :
        ensure => present,
      }
    
      # http://raftaman.net/?p=1311 for generating password
      # password = oracle
      user { 'wls' :
        ensure     => present,
        groups     => 'dba',
        shell      => '/bin/bash',
        password   => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
        home       => "/home/wls",
        comment    => 'wls user created by Puppet',
        managehome => true,
        require    => Group['dba'],
      }
    
      $install = [ 'binutils.x86_64','unzip.x86_64']
    
    
      package { $install:
        ensure  => present,
      }
    
      class { 'limits':
        config => {
                   '*'       => {  'nofile'  => { soft => '2048'   , hard => '8192',   },},
                   'wls'     => {  'nofile'  => { soft => '65536'  , hard => '65536',  },
                                   'nproc'   => { soft => '2048'   , hard => '16384',   },
                                   'memlock' => { soft => '1048576', hard => '1048576',},
                                   'stack'   => { soft => '10240'  ,},},
                   },
        use_hiera => false,
      }
    
      sysctl { 'kernel.msgmnb':                 ensure => 'present', permanent => 'yes', value => '65536',}
      sysctl { 'kernel.msgmax':                 ensure => 'present', permanent => 'yes', value => '65536',}
      sysctl { 'kernel.shmmax':                 ensure => 'present', permanent => 'yes', value => '2588483584',}
      sysctl { 'kernel.shmall':                 ensure => 'present', permanent => 'yes', value => '2097152',}
      sysctl { 'fs.file-max':                   ensure => 'present', permanent => 'yes', value => '6815744',}
      sysctl { 'net.ipv4.tcp_keepalive_time':   ensure => 'present', permanent => 'yes', value => '1800',}
      sysctl { 'net.ipv4.tcp_keepalive_intvl':  ensure => 'present', permanent => 'yes', value => '30',}
      sysctl { 'net.ipv4.tcp_keepalive_probes': ensure => 'present', permanent => 'yes', value => '5',}
      sysctl { 'net.ipv4.tcp_fin_timeout':      ensure => 'present', permanent => 'yes', value => '30',}
      sysctl { 'kernel.shmmni':                 ensure => 'present', permanent => 'yes', value => '4096', }
      sysctl { 'fs.aio-max-nr':                 ensure => 'present', permanent => 'yes', value => '1048576',}
      sysctl { 'kernel.sem':                    ensure => 'present', permanent => 'yes', value => '250 32000 100 128',}
      sysctl { 'net.ipv4.ip_local_port_range':  ensure => 'present', permanent => 'yes', value => '9000 65500',}
      sysctl { 'net.core.rmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
      sysctl { 'net.core.rmem_max':             ensure => 'present', permanent => 'yes', value => '4194304', }
      sysctl { 'net.core.wmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
      sysctl { 'net.core.wmem_max':             ensure => 'present', permanent => 'yes', value => '1048576',}
    
    }
    
    class ssh {
      require os
    
      notice 'class ssh'
    
      file { "/home/wls/.ssh/":
        owner  => "wls",
        group  => "dba",
        mode   => "700",
        ensure => "directory",
        alias  => "wls-ssh-dir",
      }
      
      file { "/home/wls/.ssh/id_rsa.pub":
        ensure  => present,
        owner   => "wls",
        group   => "dba",
        mode    => "644",
        source  => "puppet:///middleware/ssh/id_rsa.pub",
        require => File["wls-ssh-dir"],
      }
      
      file { "/home/wls/.ssh/id_rsa":
        ensure  => present,
        owner   => "wls",
        group   => "dba",
        mode    => "600",
        source  => "puppet:///middleware/ssh/id_rsa",
        require => File["wls-ssh-dir"],
      }
      
      file { "/home/wls/.ssh/authorized_keys":
        ensure  => present,
        owner   => "wls",
        group   => "dba",
        mode    => "644",
        source  => "puppet:///middleware/ssh/id_rsa.pub",
        require => File["wls-ssh-dir"],
      }        
    }
    
    class java {
      require os
    
      notice 'class java'
    
      $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]
    
      package { $remove:
        ensure  => absent,
      }
    
      include jdk7
    
      jdk7::install7{ 'jdk1.7.0_51':
          version              => "7u51" , 
          fullVersion          => "jdk1.7.0_51",
          alternativesPriority => 18000, 
          x64                  => true,
          downloadDir          => "/data/install",
          urandomJavaFix       => true,
          sourcePath           => "puppet:///middleware/",
      }
    
    }
    
    
    class bsu{
      require orawls::weblogic
    
      notice 'class bsu'
      $default_params = {}
      $bsu_instances = hiera('bsu_instances', [])
      create_resources('orawls::bsu',$bsu_instances, $default_params)
    }
    
    class domains{
      require orawls::weblogic, bsu
    
      notice 'class domains'
      $default_params = {}
      $domain_instances = hiera('domain_instances', [])
      create_resources('orawls::domain',$domain_instances, $default_params)
    }
    
    class nodemanager {
      require orawls::weblogic, domains
    
      notify { 'class nodemanager':} 
      $default_params = {}
      $nodemanager_instances = hiera('nodemanager_instances', [])
      create_resources('orawls::nodemanager',$nodemanager_instances, $default_params)
    }
    
    class startwls {
      require orawls::weblogic, domains,nodemanager
    
    
      notify { 'class startwls':} 
      $default_params = {}
      $control_instances = hiera('control_instances', [])
      create_resources('orawls::control',$control_instances, $default_params)
    }
    
    class userconfig{
      require orawls::weblogic, domains, nodemanager, startwls 
    
      notify { 'class userconfig':} 
      $default_params = {}
      $userconfig_instances = hiera('userconfig_instances', [])
      create_resources('orawls::storeuserconfig',$userconfig_instances, $default_params)
    } 
    
    class machines{
      require userconfig
    
      notify { 'class machines':} 
      $default_params = {}
      $machines_instances = hiera('machines_instances', [])
      create_resources('orawls::wlstexec',$machines_instances, $default_params)
    }
    
    
    class managed_servers{
      require machines
      notify { 'class managed_servers 2':} 
      $default_params = {}
      $server_instances = hiera('server_instances', [])
      create_resources('orawls::wlstexec',$server_instances, $default_params)
    
    }
    
    class clusters{
      require managed_servers
      notify { 'class clusters 2':} 
      $default_params = {}
      $cluster_instances = hiera('cluster_instances', [])
      create_resources('orawls::wlstexec',$cluster_instances, $default_params)
    
    }
    
    class jms_servers{
      require clusters
      notify { 'class jms_servers':} 
    }
    
    
    class jms_modules{
      require jms_servers
      notify { 'class jms_modules':} 
    }
    
    
    class pack_domain{
      require jms_modules
      
      notify { 'class pack_domain':} 
      $default_params = {}
      $pack_domain_instances = hiera('pack_domain_instances', $default_params)
      create_resources('orawls::packdomain',$pack_domain_instances, $default_params)
    }
    
    



wls_nodes.pp for the weblogic cluster nodes
-------------------------------------------


    class wls_nodes {
      
      include os, ssh, java, orawls::weblogic, bsu_nodes, orautils, copydomain_nodes, nodemanager_nodes
    
      Class['java'] -> Class['orawls::weblogic'] 
    }
    
    class bsu_nodes {
      require orawls::weblogic
    
      notify { 'class bsu':} 
      $default_params = {}
      $bsu_instances = hiera('bsu_instances', [])
      create_resources('orawls::bsu',$bsu_instances, $default_params)
    }
    
    class copydomain_nodes {
      require orawls::weblogic, bsu_nodes
    
    
      notify { 'class copydomain':} 
      $default_params = {}
      $copy_instances = hiera('copy_instances', [])
      create_resources('orawls::copydomain',$copy_instances, $default_params)
    
    }
    
    
    class nodemanager_nodes {
      require orawls::weblogic, bsu_nodes, copydomain_nodes
    
      notify { 'class nodemanager':} 
      $default_params = {}
      $nodemanager_instances = hiera('nodemanager_instances', [])
      create_resources('orawls::nodemanager',$nodemanager_instances, $default_params)
    }
   
