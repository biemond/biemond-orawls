Oracle WebLogic / Fusion Middleware puppet module V2
====================================================

Got the same options as the wls module but optimized for Hiera, totally refactored and only for Linux

For full hiera examples, see the usages below this page

created by Edwin Biemond  email biemond at gmail dot com   
[biemond.blogspot.com](http://biemond.blogspot.com)    
[Github homepage](https://github.com/biemond/biemond-orawls)  

Should work for all Linux versions like RedHat, CentOS, Ubuntu, Debian, Suse SLES or OracleLinux  

Reference implementation, the vagrant test case for full working WebLogic 12.1.2 example  
https://github.com/biemond/biemond-orawls-vagrant  


Oracle Big files and alternate download location
------------------------------------------------
Some manifests like weblogic.pp supports an alternative mountpoint for the big oracle setup/install files.  
When not provided it uses the files location of the wls puppet module  
else you can use $source => "/mnt" or "puppet:///modules/orawls/" (default) or  "puppet:///middleware/" 

Orawls WebLogic Features
------------------------
- installs WebLogic 10g,11g,12c( 12.1.1 & 12.1.2 )
- creates a standard WebLogic domain
- Startup the nodemanager
- Start or stop AdminServer, Managed or a Cluster

Orawls WebLogic Facter
----------------------

Contains WebLogic Facter which displays the following
- Middleware homes
- Oracle Software
- BSU & OPatch patches
- Domain configuration ( everything of a WebLogic Domain like deployments, datasource, JMS, SAF)


### My orawls module Files folder  
you need to download all the Oracle binaries and agree to the Oracle (Developer) License

WebLogic 11g:
- wls1036_generic.jar

WebLogic 11g BSU patches: 
- p13573621_1036_Generic.zip
- p14736139_1036_Generic.zip  

WebLogic 12.1.2:
- wls_121200.jar
- fmw_infra_121200.jar

WebLogic Operating Settings like User, Group, ULimits and kernel parameters
---------------------------------------------------------------------------

install the following module to set the kernel parameters  
puppet module install fiddyspence-sysctl  

install the following module to set the user limits parameters  
puppet module install erwbgy-limits  

     sysctl { 'kernel.msgmnb':                 ensure => 'present', permanent => 'yes', value => '65536',}
     sysctl { 'kernel.msgmax':                 ensure => 'present', permanent => 'yes', value => '65536',}
     sysctl { 'kernel.shmmax':                 ensure => 'present', permanent => 'yes', value => '2147483648',}
     sysctl { 'kernel.shmall':                 ensure => 'present', permanent => 'yes', value => '2097152',}
     sysctl { 'fs.file-max':                   ensure => 'present', permanent => 'yes', value => '344030',}
     sysctl { 'net.ipv4.tcp_keepalive_time':   ensure => 'present', permanent => 'yes', value => '1800',}
     sysctl { 'net.ipv4.tcp_keepalive_intvl':  ensure => 'present', permanent => 'yes', value => '30',}
     sysctl { 'net.ipv4.tcp_keepalive_probes': ensure => 'present', permanent => 'yes', value => '5',}
     sysctl { 'net.ipv4.tcp_fin_timeout':      ensure => 'present', permanent => 'yes', value => '30',}
   
     class { 'limits':
       config => {'*'       => {  'nofile'  => { soft => '2048'   , hard => '8192',   },},
                  'oracle'  => {  'nofile'  => { soft => '65535'  , hard => '65535',  },
                                  'nproc'   => { soft => '2048'   , hard => '2048',   },
                                  'memlock' => { soft => '1048576', hard => '1048576',},},},
       use_hiera => false,}


create user and group


    group { 'dba' :
      ensure => present,
    }
    
    # http://raftaman.net/?p=1311 for generating password
    user { 'oracle' :
      ensure     => present,
      groups     => $group,
      shell      => '/bin/bash',
      password   => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
      home       => "/home/${user}",
      comment    => 'Oracle user created by Puppet',
      managehome => true,
      require    => Group['dba'],
    }


Necessary Hiera setup for global vars and Facter
------------------------------------------------

if you don't want to provide the same parameters in all the defines and classes 


hiera.yaml main configuration

     ---
     :backends: yaml
     :yaml:
       :datadir: /vagrant/puppet/hieradata
     :hierarchy:
       - "%{::fqdn}"
       - common


vagrantcentos64.example.com.yaml

     ---

common.yaml

    ---
    # global WebLogic vars
    wls_oracle_base_home_dir: &wls_oracle_base_home_dir "/opt/oracle"
    wls_weblogic_home_dir:    &wls_weblogic_home_dir    "/opt/oracle/middleware12c/wlserver"
    wls_middleware_home_dir:  &wls_middleware_home_dir  "/opt/oracle/middleware12c"
    wls_version:              &wls_version              1212
    wls_weblogic_user:        "weblogic"
    
    # global OS vars
    wls_os_user:              &wls_os_user              "oracle"
    wls_os_group:             &wls_os_group             "dba"
    wls_download_dir:         &wls_download_dir         "/data/install"
    wls_source:               &wls_source               "/vagrant"
    wls_jdk_home_dir:         &wls_jdk_home_dir         "/usr/java/jdk1.7.0_45"
    wls_log_dir:              "/data/logs"
    

WebLogic Module Usage
---------------------

###orawls::weblogic
installs WebLogic 10.3.[0-6], 12.1.1 or 12.1.2  


    class{'orawls::weblogic':                             
      version              => 1212,                       # 1036|1211|1212
      filename             => 'wls_121200.jar',           # wls1036_generic.jar|wls1211_generic.jar|wls_121200.jar
      jdk_home_dir         => '/usr/java/jdk1.7.0_45',    
      oracle_base_home_dir => "/opt/oracle",              
      middleware_home_dir  => "/opt/oracle/middleware12c",
      os_user              => "oracle",                   
      os_group             => "dba",                      
      download_dir         => "/data/install",            
      source               => "/vagrant",                 # puppet:///modules/orawls/ | /mnt |
      log_output           => true,                      
    }


Same configuration but then with Hiera ( need to have puppet > 3.0 )    


    include orawls::weblogic

or this


    class{'orawls::weblogic':
      log_output => true,
    }


vagrantcentos64.example.com.yaml

     ---
     orawls::weblogic::log_output:   true


common.yaml

    ---
    # global WebLogic vars
    wls_oracle_base_home_dir: &wls_oracle_base_home_dir "/opt/oracle"
    wls_weblogic_home_dir:    &wls_weblogic_home_dir    "/opt/oracle/middleware12c/wlserver"
    wls_middleware_home_dir:  $wls_middleware_home_dir  "/opt/oracle/middleware12c"
    wls_version:              &wls_version              1212
    wls_weblogic_user:        "weblogic"
    
    # global OS vars
    wls_os_user:              &wls_os_user              "oracle"
    wls_os_group:             &wls_os_group             "dba"
    wls_download_dir:         &wls_download_dir         "/data/install"
    wls_source:               &wls_source               "/vagrant"
    wls_jdk_home_dir:         &wls_jdk_home_dir         "/usr/java/jdk1.7.0_45"
    wls_log_dir:              "/data/logs"
    
    
    #WebLogic installation variables 
    orawls::weblogic::version:              *wls_version
    orawls::weblogic::filename:             "wls_121200.jar"
    orawls::weblogic::middleware_home_dir:  *wls_middleware_home_dir
    orawls::weblogic::log_output:           false
    
    # hiera default anchors
    orawls::weblogic::jdk_home_dir:         *wls_jdk_home_dir
    orawls::weblogic::oracle_base_home_dir: *wls_oracle_base_home_dir
    orawls::weblogic::os_user:              *wls_os_user
    orawls::weblogic::os_group:             *wls_os_group
    orawls::weblogic::download_dir:         *wls_download_dir
    orawls::weblogic::source:               *wls_source
    


###orawls::domain 
creates WebLogic a standard WebLogic Domain

    orawls::domain { 'wlsDomain12c':
      version                    => 1212,  # 1036|1111|1211|1212
      weblogic_home_dir          => "/opt/oracle/middleware12c/wlserver",
      middleware_home_dir        => "/opt/oracle/middleware12c",
      jdk_home_dir               => "/usr/java/jdk1.7.0_45",
      domain_template            => "standard",
      domain_name                => "Wls12c",
      development_mode           => false,
      adminserver_name           => "AdminServer",
      adminserver_address        => "localhost",
      adminserver_port           => 7001,
      nodemanager_port           => 5556,
      weblogic_user              => "weblogic",
      weblogic_password          => "weblogic1",
      os_user                    => "oracle",
      os_group                   => "dba",
      log_dir                    => "/data/logs",
      download_dir               => "/data/install",
      log_output                 => true,
    }                             

or when you set the defaults hiera variables

    orawls::domain { 'wlsDomain12c':
      domain_template            => "standard",
      domain_name                => "Wls12c",
      development_mode           => false,
      adminserver_name           => "AdminServer",
      adminserver_address        => "localhost",
      adminserver_port           => 7001,
      nodemanager_port           => 5556,
      weblogic_password          => "weblogic1",
      log_output                 => true,
    }                             


Same configuration but then with Hiera ( need to have puppet > 3.0 )    


    $default = {}
    $domain_instances = hiera('domain_instances', [])
    create_resources('orawls::domain',$domain_instances, $default)


vagrantcentos64.example.com.yaml

    ---
    domain_instances:
      'wlsDomain12c':
         version:              1212
         weblogic_home_dir     "/opt/oracle/middleware12c/wlserver"
         middleware_home_dir   "/opt/oracle/middleware12c"
         jdk_home_dir          "/usr/java/jdk1.7.0_45"
         domain_template:      "standard"
         domain_name:          "Wls12c"
         jdk_home_dir:         "/usr/java/jdk1.7.0_45"
         development_mode:     false
         adminserver_name:     "AdminServer"
         adminserver_address:  "localhost"
         adminserver_port:     7001
         nodemanager_port:     5556
         weblogic_user:        "weblogic"
         weblogic_password:    "weblogic1"
         os_user:              "oracle"
         os_group:             "dba"
         log_dir:              "/data/logs"
         download_dir:         "/data/install"
         log_output:           true

or when you set the defaults hiera variables

    ---
    domain_instances:
      'wlsDomain12c':
         domain_template:      "standard"
         domain_name:          "Wls12c"
         development_mode:     false
         adminserver_name:     "AdminServer"
         adminserver_address:  "localhost"
         adminserver_port:     7001
         nodemanager_port:     5556
         weblogic_password:    "weblogic1"
         log_output:           true
    

###orawls::nodemanager 
start the nodemanager of a WebLogic Domain or Middleware Home

    orawls::nodemanager{'nodemanager12c':
      version                    => 1212, # 1036|1111|1211|1212
      weblogic_home_dir          => "/opt/oracle/middleware12c/wlserver",
      jdk_home_dir               => "/usr/java/jdk1.7.0_45",
      nodemanager_port           => 5556,
      domain_name                => "Wls12c",     
      os_user                    => "oracle",
      os_group                   => "dba",
      log_dir                    => "/data/logs",
      download_dir               => "/data/install",
      log_output                 => true,
    }  

or when you set the defaults hiera variables

    orawls::nodemanager{'nodemanager12c':
      nodemanager_port           => 5556,
      domain_name                => "Wls12c",     
      log_output                 => true,
    }

Same configuration but then with Hiera ( need to have puppet > 3.0 )    

    $default = {}
    $nodemanager_instances = hiera('nodemanager_instances', [])
    create_resources('orawls::nodemanager',$nodemanager_instances, $default)

vagrantcentos64.example.com.yaml

    ---
    nodemanager_instances:
      'nodemanager12c':
         version:              1212
         weblogic_home_dir     "/opt/oracle/middleware12c/wlserver"
         jdk_home_dir          "/usr/java/jdk1.7.0_45"
         nodemanager_port:     5556
         domain_name:          "Wls12c"
         os_user:              "oracle"
         os_group:             "dba"
         log_dir:              "/data/logs"
         download_dir:         "/data/install"
         log_output:           true

or when you set the defaults hiera variables

    ---
    nodemanager_instances:
      'nodemanager12c':
         nodemanager_port:     5556
         domain_name:          "Wls12c"
         log_output:           true


###orawls::control 
start or stops the AdminServer,Managed Server or a Cluster of a WebLogic Domain

    orawls::control{'startWLSAdminServer12c':
      domain_name                => "Wls12c",
      domain_dir                 => "/opt/oracle/middleware12c/user_projects/domains/Wls12c",
      server_type                => 'admin',  # admin|managed
      target                     => 'Server', # Server|Cluster
      server                     => 'AdminServer',
      action                     => 'start',
      weblogic_home_dir          => "/opt/oracle/middleware12c/wlserver",
      jdk_home_dir               => "/usr/java/jdk1.7.0_45",
      weblogic_user              => "weblogic",
      weblogic_password          => "weblogic1",
      adminserver_address        => 'localhost',
      adminserver_port           => 7001,
      nodemanager_port           => 5556,
      os_user                    => "oracle",
      os_group                   => "dba",
      download_dir               => "/data/install",
      log_output                 => true,
    }

or when you set the defaults hiera variables

    orawls::control{'startWLSAdminServer12c':
      domain_name                => "Wls12c",
      domain_dir                 => "/opt/oracle/middleware12c/user_projects/domains/Wls12c",
      server_type                => 'admin',  # admin|managed
      target                     => 'Server', # Server|Cluster
      server                     => 'AdminServer',
      action                     => 'start',
      weblogic_password          => "weblogic1",
      adminserver_address        => 'localhost',
      adminserver_port           => 7001,
      nodemanager_port           => 5556,
      log_output                 => true,
     }


Same configuration but then with Hiera ( need to have puppet > 3.0 )    
 
    $default = {}
    $control_instances = hiera('control_instances', [])
    create_resources('orawls::control',$control_instances, $default)
 
 
vagrantcentos64.example.com.yaml

    ---
    control_instances:
      'startWLSAdminServer12c':
         domain_name:          "Wls12c"
         domain_dir:           "/opt/oracle/middleware12c/user_projects/domains/Wls12c"
         server_type:          'admin'
         target:               'Server'
         server:               'AdminServer'
         action:               'start'
         weblogic_home_dir     "/opt/oracle/middleware12c/wlserver"
         jdk_home_dir          "/usr/java/jdk1.7.0_45"
         weblogic_user:        "weblogic"
         weblogic_password:    "weblogic1"
         adminserver_address:  'localhost'
         adminserver_port:     7001
         nodemanager_port:     5556
         os_user:              "oracle"
         os_group:             "dba"
         download_dir:         "/data/install"
         log_output:           true

or when you set the defaults hiera variables

    ---
    control_instances:
      'startWLSAdminServer12c':
         domain_name:          "Wls12c"
         domain_dir:           "/opt/oracle/middleware12c/user_projects/domains/Wls12c"
         server_type:          'admin'
         target:               'Server'
         server:               'AdminServer'
         action:               'start'
         weblogic_password:    "weblogic1"
         adminserver_address:  'localhost'
         adminserver_port:     7001
         nodemanager_port:     5556
         log_output:           true
    



