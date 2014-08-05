#Oracle WebLogic / Fusion Middleware puppet module V2
[![Build Status](https://travis-ci.org/biemond/biemond-orawls.svg?branch=master)](https://travis-ci.org/biemond/biemond-orawls) [![Coverage Status](https://coveralls.io/repos/biemond/biemond-orawls/badge.png?branch=master)](https://coveralls.io/r/biemond/biemond-orawls?branch=master)

created by Edwin Biemond email biemond at gmail dot com   
[biemond.blogspot.com](http://biemond.blogspot.com)    
[Github homepage](https://github.com/biemond/biemond-orawls)  

Got the same options as the WLS puppet module but with 
- types & providers instead of wlstexec scripts ( detect changes )
- more FMW product installations 
- support for FMW clusters ( SOA Suite,OSB & ADF )
- optimized for Hiera
- totally refactored
- only for Linux and Solaris

Many thanks to Bert Hajee (hajee) for his contributions, help and the his easy_type module  
[![Powered By EasyType](https://raw.github.com/hajee/easy_type/master/powered_by_easy_type.png)](https://github.com/hajee/easy_type)

Should work for all Linux & Solaris versions like RedHat, CentOS, Ubuntu, Debian, Suse SLES, OracleLinux, Solaris 10,11 sparc / x86  

Dependency with 
- hajee/easy_type >=0.10.0
- adrien/filemapper >= 1.1.1
- reidmv/yamlfile >=0.2.0

##History
- 1.0.12 SOA 12.1.3 Cluster support, 12.1.3 FMW BAM Foreign JNDI + XA datasource fixes, 11g option to associate WebTier with a domain
- 1.0.11 OSB 12.1.3 Cluster support + FMW domains update for datasources based on servicetable, target & targettype on all wls types expects an array, same for servers parameter on wls_domain type + users parameter on wls_group type + virtualhostnames parameter on wls_virtual_host + jndinames, extraproperties, extrapropertiesvalues parameters on wls_datasource & wls_foreign_server 
- 1.0.10 fixed WebLogic 12.1.2 & 12.1.3 standard domain bug.
- 1.0.9 WebLogic 12.1.3 (infra) support - support for 12.1.3 SOA,OSB,B2B,MFT installation - 12.1.3 Standard, ADF, SOA, OSB domain (no cluster) - wls_adminserver type fix when using no custom trust
- 1.0.8 wls_server pass server arguments as an array, as it makes it easier to use references in YAML, Added log file options to wls_server 
- 1.0.7 wls_adminserver,wls_managedserver type to start,stop and refresh a managed server ( or subscribe to changes and do an autorestart ), bsu,opatch, resource adapter & a small nodemanager fix 
- 1.0.6 Readme with links, wls types title cleanup, multiple resource adapter entries fix, wls_domain fix, bsu & opatch also works on < puppet 3.2, hiera vars without an undef default
- 1.0.5 wls_domain type to modify JTA,Security,Log & JPA Oracle Unified Directory install, domain, instances creation & OUD control
- 1.0.4 wls_deployment type/provider, post_classpath param on wls_setting, WebTier for 12.1.2 and 11.1.1.7, OIM & OAM 11.1.2.1 & 11.1.2.2 support with OHS OAM Webgate
- 1.0.3 WLST Domain daemin for fast WLS types execution, BSU & OPatch absent option and better output when it fails
- 1.0.2 Custom Identity and Custom Trust
- 1.0.1 Multi domain support with Puppet WLS types and providers


##Complete examples
see the following usages below  

###full working vagrant boxes

- WebLogic 12.1.3 Reference implementation, the vagrant test case for full working WebLogic 12.1.3 cluster example [biemond-orawls-vagrant-12.1.3](https://github.com/biemond/biemond-orawls-vagrant-12.1.3) 
- WebLogic 12.1.3 infra (JRF), the vagrant test case for full working WebLogic 12.1.3 infra cluster example with WebTier (Oracle HTTP Server) [biemond-orawls-vagrant-12.1.3-infra](https://github.com/biemond/biemond-orawls-vagrant-12.1.3-infra)
- WebLogic 12.1.3 infra with OSB, the vagrant test case for full working WebLogic 12.1.3 infra OSB cluster example [biemond-orawls-vagrant-12.1.3-infra-osb](https://github.com/biemond/biemond-orawls-vagrant-12.1.3-infra-osb)
- WebLogic 12.1.3 infra with OSB & SOA,ESS,BAM, the vagrant test case for full working WebLogic 12.1.3 infra OSB SOA Cluster example [biemond-orawls-vagrant-12.1.3-infra-soa](https://github.com/biemond/biemond-orawls-vagrant-12.1.3-infra-soa)   
- WebLogic 12.1.2 Reference implementation, the vagrant test case for full working WebLogic 12.1.2 cluster example [biemond-orawls-vagrant-12.1.2](https://github.com/biemond/biemond-orawls-vagrant-12.1.2)   
- WebLogic 12.1.2 infra (JRF) with WebTier, the vagrant test case for full working WebLogic 12.1.2 infra cluster example with WebTier (Oracle HTTP Server) [biemond-orawls-vagrant-12.1.2-infra](https://github.com/biemond/biemond-orawls-vagrant-12.1.2-infra) 
- Reference Solaris implementation, the vagrant test case for full working WebLogic 12.1.2 cluster example [biemond-orawls-vagrant-solaris](https://github.com/biemond/biemond-orawls-vagrant-solaris) 
- Reference OIM / OAM with WebTier, Webgate & Oracle Unified Directory, the vagrant test case for Oracle Identity Manager & Oracle Access Manager 11.1.2.2 example [biemond-orawls-vagrant-oim_oam](https://github.com/biemond/biemond-orawls-vagrant-oim_oam) 
- WebLogic 11g Reference implementation, the vagrant test case for full working WebLogic 10.3.6 cluster example [biemond-orawls-vagrant](https://github.com/biemond/biemond-orawls-vagrant) 
- Reference Oracle SOA Suite, the vagrant test case for full working WebLogic 10.3.6 SOA Suite + OSB cluster example [biemond-orawls-vagrant-solaris-soa](https://github.com/biemond/biemond-orawls-vagrant-solaris-soa) 
- Example of Opensource Puppet 3.4.3 Puppet master configuration in a vagrant box [vagrant-puppetmaster](https://github.com/biemond/vagrant-puppetmaster)

##Orawls WebLogic Features

- [Installs WebLogic](#weblogic), version 10g,11g,12c( 12.1.1 & 12.1.2 & 12.1.3 + FMW infra )
- [Apply a BSU patch](#bsu) on a Middleware home ( < 12.1.2 )
- [Apply a OPatch](#opatch) on a Middleware home ( >= 12.1.2 ) or a Oracle product home
- [Create a WebLogic domain](#domain)
- [Pack a WebLogic domain](#packdomain)
- [Copy a WebLogic domain](#copydomain) to a other node with SSH, unpack and enroll to a nodemanager
- [JSSE](#jsse) Java Secure Socket Extension support
- [Custom Identity and Trust Store support](#identity)
- [Linux low on entropy or urandom fix](#urandom)
- [Startup a nodemanager](#nodemanager)
- [start or stop AdminServer, Managed or a Cluster](#control)
- [StoreUserConfig](#storeuserconfig) for storing WebLogic Credentials and using in WLST

###Fusion Middleware Features 11g & 12.1.3
- installs [FMW](#fmw) software(add-on) to a middleware home, like OSB,SOA Suite, Oracle Identity & Access Management, Oracle Unified Directory, WebCenter Portal + Content
- [WebTier](#webtier) Oracle HTTP server
- [OSB, SOA Suite](#fmwcluster) ( with BPM ) and BAM Cluster configuration support ( convert single osb/soa/bam servers to clusters and migrate OPSS to the database )
- [ADF/JRF support](#fmwclusterjrf), Assign JRF libraries to a Server or Cluster target
- [OIM IDM](#oimconfig) / OAM configurations with Oracle OHS OAM WebGate
- [OUD](#instance) OUD Oracle Unified Directory install, WebLogic domain, instances creation & [OUD control](#oud_control)
- [Change FMW log](#fmwlogdir) location of a managed server
- [Resource Adapter](#resourceadapter) plan and entries for AQ, DB and JMS

##Wls types and providers
ensurable -> create,modify,destroy + puppet resource support

- [wls_setting](#wls_setting), set the default wls parameters for the other types and also used by puppet resource
- [wls_adminserver](#wls_adminserver) control the adminserver or subscribe to changes
- [wls_managedserver](#wls_managedserver) control the managed server,cluster or subscribe to changes
- [wls_domain](#wls_domain)
- [wls_deployment](#wls_deployment)
- [wls_domain](#wls_domain)
- [wls_user](#wls_user)
- [wls_authentication_provider](#wls_authentication_provider)
- [wls_machine](#wls_machine)
- [wls_server](#wls_server)
- [wls_server_channel](#wls_server_channel)
- [wls_cluster](#wls_cluster)
- [wls_virtual_host](#wls_virtual_host)
- [wls_workmanager_constraint](#wls_workmanager_constraint)
- [wls_workmanager](#wls_workmanager)
- [wls_datasource](#wls_datasource)
- [wls_file_persistence_store](#wls_file_persistence_store)
- [wls_jmsserver](#wls_jmsserver)
- [wls_safagent](#wls_safagent)
- [wls_jms_module](#wls_jms_module)
- [wls_jms_quota](#wls_jms_quota)
- [wls_jms_subdeployment](#wls_jms_subdeployment)
- [wls_jms_queue](#wls_jms_queue)
- [wls_jms_topic](#wls_jms_topic)
- [wls_jms_connection_factory](#wls_jms_connection_factory)
- [wls_saf_remote_context](#wls_saf_remote_context)
- [wls_saf_error_handler](#wls_saf_error_handler)
- [wls_saf_imported_destination](#wls_saf_imported_destination)
- [wls_saf_imported_destination_object](#wls_saf_imported_destination_object)
- [wls_foreign_server](#wls_foreign_server)
- [wls_foreign_server_object](#wls_foreign_server_object)


##Domain creation options (Dev or Prod mode)

all templates creates a WebLogic domain, logs the domain creation output 

- domain 'standard'    -> a default WebLogic    
- domain 'adf'         -> JRF + EM + Coherence (12.1.2 & 12.1.3) + OWSM (12.1.2 & 12.1.3) + JAX-WS Advanced + Soap over JMS (12.1.2 & 12.1.3)   
- domain 'osb'         -> OSB + JRF + EM + OWSM 
- domain 'osb_soa'     -> OSB + SOA Suite + BAM + JRF + EM + OWSM 
- domain 'osb_soa_bpm' -> OSB + SOA Suite + BAM + BPM + JRF + EM + OWSM 
- domain 'soa'         -> SOA Suite + BAM + JRF + EM + OWSM 
- domain 'soa_bpm'     -> SOA Suite + BAM + BPM + JRF + EM + OWSM 
- domain 'wc_wcc_bpm'  -> WC (webcenter) + WCC ( Content ) + BPM + JRF + EM + OWSM 
- domain 'wc'          -> WC (webcenter) + JRF + EM + OWSM 
- domain 'oim'         -> OIM (Oracle Identity Manager) + OAM ( Oracle Access Manager)  
- domain 'oud'         -> OUD (Oracle Unified Directory)  


##Orawls WebLogic Facter

Contains WebLogic Facter which displays the following
- Middleware homes
- Oracle Software
- BSU & OPatch patches
- Domain configuration ( everything of a WebLogic Domain like deployments, datasource, JMS, SAF)


##Override the default Oracle operating system user

default this orawls module uses oracle as weblogic install user  
you can override this by setting the following fact 'override_weblogic_user', like override_weblogic_user=wls or set FACTER_override_weblogic_user=wls  

##Override the default WebLogic domain folder

Set the following hiera parameters for weblogic.pp

    wls_domains_dir:   '/opt/oracle/wlsdomains/domains'
    wls_apps_dir:      '/opt/oracle/wlsdomains/applications'

Set the following wls_domains_dir & wls_apps_dir parameters in 
- weblogic.pp
- domain.pp
- control.pp
- packdomain.pp
- copydomain.pp
- fmwcluster.pp
- fmwclusterjrf.pp

or hiera parameters of weblogic.pp

    orawls::weblogic::wls_domains_dir:      *wls_domains_dir
    orawls::weblogic::wls_apps_dir:         *wls_apps_dir

##<a name="jsse">Java Secure Socket Extension support</a> 

Requires the JDK 7 or 8 JCE extension 

    jdk7::install7{ 'jdk1.7.0_51':
        version                   => "7u51" , 
        fullVersion               => "jdk1.7.0_51",
        alternativesPriority      => 18000, 
        x64                       => true,
        downloadDir               => "/data/install",
        urandomJavaFix            => true,
        rsakeySizeFix             => true,                          <!-- 
        cryptographyExtensionFile => "UnlimitedJCEPolicyJDK7.zip",  <!---
        sourcePath                => "/software",
    }

To enable this in orawls you can set the jsse_enabled on the following manifests
- nodemanager.pp
- domain.pp
- control.pp

or set the following hiera parameter
     
     wls_jsse_enabled:         true

##<a name="identity">Enterprise security with Custom Identity and Trust store</a>

in combination with JDK7 JCE policy, ORAUTILS and WebLogic JSSE you can use your own certificates 

just generates all the certificates and set the following hiera variables.

    # custom trust
    orautils::customTrust:             true
    orautils::trustKeystoreFile:       '/vagrant/truststore.jks'
    orautils::trustKeystorePassphrase: 'welcome'

    # used by nodemanager, control and domain creation
    wls_custom_trust:                  &wls_custom_trust              true
    wls_trust_keystore_file:           &wls_trust_keystore_file       '/vagrant/truststore.jks'
    wls_trust_keystore_passphrase:     &wls_trust_keystore_passphrase 'welcome'

    # create a standard domain with custom identity for the adminserver
    domain_instances:
      'Wls1036':
        domain_template:                       "standard"
        development_mode:                      false
        log_output:                            *logoutput
        custom_identity:                       true
        custom_identity_keystore_filename:     '/vagrant/identity_admin.jks'
        custom_identity_keystore_passphrase:   'welcome'
        custom_identity_alias:                 'admin'
        custom_identity_privatekey_passphrase: 'welcome'

    nodemanager_instances:
      'nodemanager':
        log_output:                            *logoutput
        custom_identity:                       true
        custom_identity_keystore_filename:     '/vagrant/identity_admin.jks'
        custom_identity_keystore_passphrase:   'welcome'
        custom_identity_alias:                 'admin'
        custom_identity_privatekey_passphrase: 'welcome'
        nodemanager_address:                   *domain_adminserver_address

        server_instances:
          'wlsServer1':
            ensure:                                'present'
            arguments:                             '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer1.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer1_err.out'
            listenaddress:                         '10.10.10.100'
            listenport:                            '8001'
            logfilename:                           '/var/log/weblogic/wlsServer1.log'
            machine:                               'Node1'
            sslenabled:                            '1'
            ssllistenport:                         '8201'
            sslhostnameverificationignored:        '1'
            jsseenabled:                           '1' 
            custom_identity:                       '1'
            custom_identity_keystore_filename:     '/vagrant/identity_node1.jks'
            custom_identity_keystore_passphrase:   'welcome'
            custom_identity_alias:                 'node1'
            custom_identity_privatekey_passphrase: 'welcome'
            trust_keystore_file:                   *wls_trust_keystore_file
            trust_keystore_passphrase:             *wls_trust_keystore_passphrase


##<a name="urandom">Linux low on entropy or urandom fix</a> 

can cause certain operations to be very slow. Encryption operations need entropy to ensure randomness. Entropy is generated by the OS when you use the keyboard, the mouse or the disk.

If an encryption operation is missing entropy it will wait until enough is generated.

three options  
-  use rngd service (include __orawls::urandomfix__ class)  
-  set java.security in JDK ( jre/lib/security in my jdk7 module )  
-  set -Djava.security.egd=file:/dev/./urandom param 

##Oracle binaries files and alternate download location

Some manifests like orawls:weblogic bsu opatch fmw supports an alternative mountpoint for the big oracle setup/install files.  
When not provided it uses the files folder located in the orawls puppet module  
else you can use $source =>
- "/mnt"
- "/vagrant"
- "puppet:///modules/orawls/" (default)
- "puppet:///middleware/"  

when the files are also accesiable locally then you can also set $remote_file => false this will not move the files to the download folder, just extract or install 

##WebLogic requirements

Operating System settings like User, Group, ULimits and kernel parameters requirements

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


create a WebLogic user and group


    group { 'dba' :
      ensure => present,
    }
    
    # http://raftaman.net/?p=1311 for generating password
    user { 'oracle' :
      ensure     => present,
      groups     => 'dba',
      shell      => '/bin/bash',
      password   => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
      home       => "/home/oracle",
      comment    => 'Oracle user created by Puppet',
      managehome => true,
      require    => Group['dba'],
    }


##Necessary Hiera setup for global vars and Facter

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
    wls_weblogic_user:        &wls_weblogic_user        "weblogic"
    
    # 12.1.2 settings
    #wls_weblogic_home_dir:    &wls_weblogic_home_dir    "/opt/oracle/middleware12c/wlserver"
    #wls_middleware_home_dir:  &wls_middleware_home_dir  "/opt/oracle/middleware12c"
    #wls_version:              &wls_version              1212
    
    # 10.3.6 settings
    wls_weblogic_home_dir:    &wls_weblogic_home_dir    "/opt/oracle/middleware11g/wlserver_10.3"
    wls_middleware_home_dir:  &wls_middleware_home_dir  "/opt/oracle/middleware11g"
    wls_version:              &wls_version              1036
    
    # global OS vars
    wls_os_user:              &wls_os_user              "oracle"
    wls_os_group:             &wls_os_group             "dba"
    wls_download_dir:         &wls_download_dir         "/data/install"
    wls_source:               &wls_source               "/vagrant"
    wls_jdk_home_dir:         &wls_jdk_home_dir         "/usr/java/jdk1.7.0_45"
    wls_log_dir:              &wls_log_dir              "/data/logs"
    
    
    #WebLogic installation variables 
    orawls::weblogic::version:              *wls_version
    orawls::weblogic::filename:             "wls1036_generic.jar"
    
    # weblogic 12.1.2
    #orawls::weblogic::filename:             "wls_121200.jar"
    # or with 12.1.2 FMW infra
    #orawls::weblogic::filename:             "fmw_infra_121200.jar"
    #orawls::weblogic::fmw_infra:            true
    
    orawls::weblogic::middleware_home_dir:  *wls_middleware_home_dir
    orawls::weblogic::log_output:           false
    
    # hiera default anchors
    orawls::weblogic::jdk_home_dir:         *wls_jdk_home_dir
    orawls::weblogic::oracle_base_home_dir: *wls_oracle_base_home_dir
    orawls::weblogic::os_user:              *wls_os_user
    orawls::weblogic::os_group:             *wls_os_group
    orawls::weblogic::download_dir:         *wls_download_dir
    orawls::weblogic::source:               *wls_source
        

##WebLogic Module Usage

###weblogic
__orawls::weblogic__ installs WebLogic 10.3.[0-6], 12.1.1, 12.1.2 & 12.1.3  

    class{'orawls::weblogic':                             
      version              => 1212,                       # 1036|1211|1212|1213
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

12.1.3 infra

    class{'orawls::weblogic':                             
      version              => 1213,
      filename             => 'fmw_12.1.3.0.0_infrastructure.jar',
      fmw_infra            => true,
      jdk_home_dir         => '/usr/java/jdk1.7.0_55',    
      oracle_base_home_dir => "/opt/oracle",              
      middleware_home_dir  => "/opt/oracle/middleware12c",
      os_user              => "oracle",                   
      os_group             => "dba",                      
      download_dir         => "/data/install",            
      source               => "puppet:///middleware",
      log_output           => true,                      
    }


or with a bin file located on a share

    class{'orawls::weblogic':                             
        version              => 1036,
        filename             => "oepe-wls-indigo-installer-11.1.1.8.0.201110211138-10.3.6-linux32.bin",
        oracle_base_home_dir => "/opt/weblogic",
        middleware_home_dir  => "/opt/weblogic/Middleware",
        fmw_infra            => false,
        jdk_home_dir         => "/usr/java/latest",
        os_user              => "weblogic",
        os_group             => "bea",
        download_dir         => "/data/tmp",
        source               => "/misc/tact/products/oracle/11g/fmw/wls/11.1.1.8",
        remote_file          => false,
        log_output           => true,
        temp_directory       => "/data/tmp",
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



###opatch 
__orawls::opatch__ apply an OPatch on a Middleware home or a Oracle product home

    orawls::opatch {'16175470':
      ensure                  => "present",
      oracle_product_home_dir => "/opt/oracle/middleware12c",
      jdk_home_dir            => "/usr/java/jdk1.7.0_45",
      patch_id                => "16175470",
      patch_file              => "p16175470_121200_Generic.zip",
      os_user                 => "oracle",
      os_group                => "dba",
      download_dir            => "/data/install",
      source                  => "/vagrant",
      log_output              => false,
    }
    

or when you set the defaults hiera variables

    orawls::opatch {'16175470':
      ensure                  => "present",
      oracle_product_home_dir => "/opt/oracle/middleware12c",
      patch_id                => "16175470",
      patch_file              => "p16175470_121200_Generic.zip",
    }
    

Same configuration but then with Hiera ( need to have puppet > 3.0 )    


    $default_params = {}
    $opatch_instances = hiera('opatch_instances', {})
    create_resources('orawls::opatch',$opatch_instances, $default_params)
  

common.yaml

    ---
    opatch_instances:
      '16175470':
         ensure:                   "present"
         oracle_product_home_dir:  "/opt/oracle/middleware12c"
         patch_id:                 "16175470"
         patch_file:               "p16175470_121200_Generic.zip"
         jdk_home_dir              "/usr/java/jdk1.7.0_45"
         os_user:                  "oracle"
         os_group:                 "dba"
         download_dir:             "/data/install"
         source:                   "/vagrant"
         log_output:               true
        


or when you set the defaults hiera variables

    ---
    opatch_instances:
      '16175470':
         ensure:                   "present"
         oracle_product_home_dir:  "/opt/oracle/middleware12c"
         patch_id:                 "16175470"
         patch_file:               "p16175470_121200_Generic.zip"
        

###bsu 
__orawls::bsu__ apply or remove a WebLogic BSU Patch ( ensure = present or absent )

    orawls::bsu {'BYJ1':
      ensure                  => "present",
      middleware_home_dir     => "/opt/oracle/middleware11gR1",
      weblogic_home_dir       => "/opt/oracle/middleware11gR1/wlserver",
      jdk_home_dir            => "/usr/java/jdk1.7.0_45",
      patch_id                => "BYJ1",
      patch_file              => "p17071663_1036_Generic.zip",
      os_user                 => "oracle",
      os_group                => "dba",
      download_dir            => "/data/install",
      source                  => "/vagrant",
      log_output              => false,
    }


or when you set the defaults hiera variables

    orawls::bsu {'BYJ1':
      ensure                  => "present",
      patch_id                => "BYJ1",
      patch_file              => "p17071663_1036_Generic.zip",
      log_output              => false,
    }


Same configuration but then with Hiera ( need to have puppet > 3.0 )    


    $default_params = {}
    $bsu_instances = hiera('bsu_instances', {})
    create_resources('orawls::bsu',$bsu_instances, $default_params)
  

common.yaml

    ---
    bsu_instances:
      'BYJ1':
         ensure                   "present"
         middleware_home_dir:     "/opt/oracle/middleware11gR1"
         weblogic_home_dir:       "/opt/oracle/middleware11gR1/wlserver"
         jdk_home_dir:            "/usr/java/jdk1.7.0_45"
         patch_id:                "BYJ1"
         patch_file:              "p17071663_1036_Generic.zip"
         os_user:                 "oracle"
         os_group:                "dba"
         download_dir:            "/data/install"
         source:                  "/vagrant"
         log_output:              false


or when you set the defaults hiera variables

    ---
    bsu_instances:
      'BYJ1':
         ensure                   "present"
         patch_id:                "BYJ1"
         patch_file:              "p17071663_1036_Generic.zip"
         log_output:              false


###fmw 
__orawls::fmw__ installs FMW software (add-on) to a middleware home like OSB,SOA Suite, WebTier (HTTP Server), Oracle Identity Management, Web Center + Content


    # fmw_product = adf|soa|osb|wcc|wc|oim|web|webgate|b2b|mft
    orawls::fmw{"osbPS6":
      middleware_home_dir     => "/opt/oracle/middleware11gR1",
      weblogic_home_dir       => "/opt/oracle/middleware11gR1/wlserver",
      jdk_home_dir            => "/usr/java/jdk1.7.0_45",
      oracle_base_home_dir    => "/opt/oracle",
      fmw_product             => "osb",  # adf|soa|osb|oim|wc|wcc|web
      fmw_file1               => "ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip",
      os_user                 => "oracle",
      os_group                => "dba",
      download_dir            => "/data/install",
      source                  => "/vagrant",
      log_output              => false,
    }
    

or when you set the defaults hiera variables

    orawls::fmw{"osbPS6":
      fmw_product             => "osb"  # adf|soa|osb|oim|wc|wcc|web|webgate
      fmw_file1               => "ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip",
      log_output              => false,
    }

    orawls::fmw{"osb12.1.3":
      version                 => 1213
      fmw_product             => "osb"
      fmw_file1               => "fmw_12.1.3.0.0_osb_Disk1_1of1.zip",
      log_output              => false,
    }

    

Same configuration but then with Hiera ( need to have puppet > 3.0 )    

    $default_params = {}
    $fmw_installations = hiera('fmw_installations', {})
    create_resources('orawls::fmw',$fmw_installations, $default_params)


common.yaml

when you set the defaults hiera variables

    if ( defined(Orawls::Fmw["b2b1213"])) {
      Orawls::Fmw["soa1213"] -> Orawls::Fmw["b2b1213"]
    }


    fmw_installations:
      'soa1213':
        version:                 *wls_version
        fmw_product:             "soa"
        fmw_file1:               "fmw_12.1.3.0.0_soa_Disk1_1of1.zip"
        bpm:                     true
        log_output:              true
        remote_file:             false
      'webtier1213':
        version:                 *wls_version
        fmw_product:             "web"
        fmw_file1:               "fmw_12.1.3.0.0_ohs_linux64_Disk1_1of1.zip"
        log_output:              true
        remote_file:             false
      'osb1213':
        version:                 *wls_version
        fmw_product:             "osb"
        fmw_file1:               "fmw_12.1.3.0.0_osb_Disk1_1of1.zip"
        log_output:              true
        remote_file:             false
      'mft1213':
        version:                 *wls_version
        fmw_product:             "mft"
        fmw_file1:               "fmw_12.1.3.0.0_mft_Disk1_1of1.zip"
        log_output:              true
        remote_file:             false
      'b2b1213':
        version:                 *wls_version
        fmw_product:             "b2b"
        healthcare:              true
        fmw_file1:               "fmw_12.1.3.0.0_b2b_Disk1_1of1.zip"
        log_output:              true
        remote_file:             false

    # FMW installation on top of WebLogic 10.3.6
    fmw_installations:
      'osbPS6':
        fmw_product:             "osb"
        fmw_file1:               "ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip"
        log_output:              true
      'soaPS6':
        fmw_product:             "soa"
        fmw_file1:               "ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip"
        fmw_file2:               "ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip"
        log_output:              true


    # FMW installation on top of WebLogic 12.1.2
    fmw_installations:
      'webtier1212':
        version:                 1212 
        fmw_product:             "web"
        fmw_file1:               "ofm_ohs_linux_12.1.2.0.0_64_disk1_1of1.zip"
        log_output:              true
        remote_file:             false

    fmw_installations:
      'webTierPS6':
        fmw_product:             "web"
        fmw_file1:               "ofm_webtier_linux_11.1.1.7.0_64_disk1_1of1.zip"
        log_output:              true
        remote_file:             false

    fmw_installations:
      'wcPS7':
        fmw_product:             "wc"
        fmw_file1:               "ofm_wc_generic_11.1.1.8.0_disk1_1of1.zip"
        log_output:              true
        remote_file:             false
      'soaPS6':
        fmw_product:             "soa"
        fmw_file1:               "ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip"
        fmw_file2:               "ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip"
        log_output:              true
        remote_file:             false
      'wccPS7':
        fmw_product:             "wcc"
        fmw_file1:               "ofm_wcc_generic_11.1.1.8.0_disk1_1of2.zip"
        fmw_file2:               "ofm_wcc_generic_11.1.1.8.0_disk1_2of2.zip"
        log_output:              true
        remote_file:             false
      'webGate11.1.2.2':
        version:                 1112
        fmw_product:             "webgate"
        fmw_file1:               "ofm_webgates_generic_11.1.2.2.0_disk1_1of1.zip"
        log_output:              true
        remote_file:             false
      'oud11.1.2.2':
        version:                 1112
        fmw_product:             "oud"
        fmw_file1:               "ofm_oud_generic_11.1.2.2.0_disk1_1of1.zip"
        log_output:              true
        remote_file:             false


###domain 
__orawls::domain__ creates WebLogic domain like a standard | OSB or SOA Suite | ADF | WebCenter | OIM or OAM or OUD   

optional override the default server arguments in the domain.py template with java_arguments parameter  

    orawls::domain { 'wlsDomain12c':
      version                    => 1212,  # 1036|1111|1211|1212|1213
      weblogic_home_dir          => "/opt/oracle/middleware12c/wlserver",
      middleware_home_dir        => "/opt/oracle/middleware12c",
      jdk_home_dir               => "/usr/java/jdk1.7.0_45",
      domain_template            => "standard",  #standard|adf|osb|osb_soa|osb_soa_bpm|soa|soa_bpm
      domain_name                => "Wls12c",
      development_mode           => false,
      adminserver_name           => "AdminServer",
      adminserver_address        => "localhost",
      adminserver_port           => 7001,
      nodemanager_port           => 5556,
      java_arguments             => { "ADM" => "...", "OSB" => "...", "SOA" => "...", "BAM" => "..."},
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
    $domain_instances = hiera('domain_instances', {})
    create_resources('orawls::domain',$domain_instances, $default)


vagrantcentos64.example.com.yaml

    ---
    domain_instances:
      'wlsDomain12c':
         version:              1212
         weblogic_home_dir:    "/opt/oracle/middleware12c/wlserver"
         middleware_home_dir:  "/opt/oracle/middleware12c"
         jdk_home_dir:         "/usr/java/jdk1.7.0_45"
         domain_template:      "standard"
         domain_name:          "Wls12c"
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
         java_arguments:      
            ADM:  "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m" 
            OSB:  "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
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
         java_arguments:      
            ADM:  "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m" 
         log_output:           true
    
when you just have one WebLogic domain on a server
     
    --- 
    # when you have just one domain on a server
    domain_name:                "Wls1036"
    domain_adminserver:         "AdminServer"
    domain_adminserver_address: "localhost"
    domain_adminserver_port:    7001
    domain_nodemanager_port:    5556
    domain_wls_password:        "weblogic1"
    
    
    # create a standard domain
    domain_instances:
      'wlsDomain':
         domain_template:      "standard"
         development_mode:     false
         log_output:           *logoutput

or with custom identity and custom truststore    

    # used by nodemanager, control and domain creation
    wls_custom_trust:                  &wls_custom_trust              true
    wls_trust_keystore_file:           &wls_trust_keystore_file       '/vagrant/truststore.jks'
    wls_trust_keystore_passphrase:     &wls_trust_keystore_passphrase 'welcome'

    # create a standard domain with custom identity for the adminserver
    domain_instances:
      'Wls1036':
        domain_template:                       "standard"
        development_mode:                      false
        log_output:                            *logoutput
        custom_identity:                       true
        custom_identity_keystore_filename:     '/vagrant/identity_admin.jks'
        custom_identity_keystore_passphrase:   'welcome'
        custom_identity_alias:                 'admin'
        custom_identity_privatekey_passphrase: 'welcome'


###packdomain 
__orawls::packdomain__ pack a WebLogic Domain and add this to the download folder

    orawls::packdomain{"Wls12c":
      weblogic_home_dir      => "/opt/oracle/middleware12c/wlserver",
      middleware_home_dir    => "/opt/oracle/middleware12c",
      jdk_home_dir           => "/usr/java/jdk1.7.0_45",
      wls_domains_dir        => "/opt/oracle/domains",
      domain_name            => "Wls12c",
      os_user                => "oracle",
      os_group               => "dba",
      download_dir           => "/data/install",
    }

or with hiera

    $default_params = {}
    $pack_domain_instances = hiera('pack_domain_instances', {})
    create_resources('orawls::packdomain',$pack_domain_instances, $default_params)

    # pack domains
    pack_domain_instances:
      'wlsDomain':
         log_output:               *logoutput


###copydomain 
__orawls::copydomain__ copies a WebLogic domain with SSH or from a share, unpack and enroll to a nodemanager

When using ssh (use_ssh = true) you need to setup ssh so you won't need to provide a password

    orawls::copydomain{"Wls12c":
      version                => 1212,
      weblogic_home_dir      => "/opt/oracle/middleware12c/wlserver",
      middleware_home_dir    => "/opt/oracle/middleware12c",
      jdk_home_dir           => "/usr/java/jdk1.7.0_45",
      wls_domains_dir        => "/opt/oracle/domains",
      wls_apps_dir           => "/opt/oracle/applications",
      domain_name            => "Wls12c",
      os_user                => "oracle",
      os_group               => "dba",
      download_dir           => "/data/install",
      log_dir                => "/var/log/weblogic",
      log_output             => true,
      use_ssh                => false,
      domain_pack_dir        => /mnt/fmw_share,
      adminserver_address    => "10.10.10.10",
      adminserver_port       => 7001,
      weblogic_user          => "weblogic",
      weblogic_password      => "weblogic1", 
    }

Configuration with Hiera ( need to have puppet > 3.0 )    


    $default_params = {}
    $copy_instances = hiera('copy_instances', {})
    create_resources('orawls::copydomain',$copy_instances, $default_params)


when you just have one WebLogic domain on a server
     
    --- 
    # when you have just one domain on a server
    domain_name:                "Wls1036"
    domain_adminserver:         "AdminServer"
    domain_adminserver_address: "localhost"
    domain_adminserver_port:    7001
    domain_nodemanager_port:    5556
    domain_wls_password:        "weblogic1"
    
    # copy domains to other nodes
    copy_instances:
      'wlsDomain':
         use_ssh:                 false
         domain_pack_dir:         /mnt/fmw_share
         log_output:              *logoutput
      'wlsDomain2':
         log_output:              *logoutput
    

###nodemanager 
__orawls::nodemanager__ start the nodemanager of a WebLogic Domain or Middleware Home

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
         weblogic_home_dir:    "/opt/oracle/middleware12c/wlserver"
         jdk_home_dir:         "/usr/java/jdk1.7.0_45"
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


when you just have one WebLogic domain on a server

    #when you just have one domain on a server
    domain_name:                "Wls1036"
    domain_nodemanager_port:    5556
    
    ---
    nodemanager_instances:
      'nodemanager12c':
         log_output:           true

or with custom identity and custom truststore    

    # used by nodemanager, control and domain creation
    wls_custom_trust:                  &wls_custom_trust              true
    wls_trust_keystore_file:           &wls_trust_keystore_file       '/vagrant/truststore.jks'
    wls_trust_keystore_passphrase:     &wls_trust_keystore_passphrase 'welcome'

    nodemanager_instances:
      'nodemanager':
        log_output:                            *logoutput
        custom_identity:                       true
        custom_identity_keystore_filename:     '/vagrant/identity_admin.jks'
        custom_identity_keystore_passphrase:   'welcome'
        custom_identity_alias:                 'admin'
        custom_identity_privatekey_passphrase: 'welcome'
        nodemanager_address:                   *domain_adminserver_address



###control 
__orawls::control__ start or stops the AdminServer,Managed Server or a Cluster of a WebLogic Domain, this will call the wls_managedserver and wls_adminserver types

    orawls::control{'startWLSAdminServer12c':
      domain_name                => "Wls12c",
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
    $control_instances = hiera('control_instances', {})
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
         weblogic_home_dir:    "/opt/oracle/middleware12c/wlserver"
         jdk_home_dir:         "/usr/java/jdk1.7.0_45"
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
    

when you just have one WebLogic domain on a server

    ---
    #when you just have one domain on a server
    domain_name:                "Wls1036"
    domain_adminserver_address: "localhost"
    domain_adminserver_port:    7001
    domain_nodemanager_port:    5556
    domain_wls_password:        "weblogic1"
    
    
        
    # startup adminserver for extra configuration
    control_instances:
      'startWLSAdminServer':
         domain_dir:           "/opt/oracle/middleware11g/user_projects/domains/Wls1036"
         server_type:          'admin'
         target:               'Server'
         server:               'AdminServer'
         action:               'start'
         log_output:           *logoutput



###urandomfix 
__orawls::urandomfix__ Linux low on entropy or urandom fix can cause certain operations to be very slow. Encryption operations need entropy to ensure randomness. Entropy is generated by the OS when you use the keyboard, the mouse or the disk.

If an encryption operation is missing entropy it will wait until enough is generated.

three options  
-  use rngd service (use this wls::urandomfix class)  
-  set java.security in JDK ( jre/lib/security in my jdk7 module )  
-  set -Djava.security.egd=file:/dev/./urandom param 


###storeuserconfig 
__orawls::storeuserconfig__ Creates WLST user config for WLST , this way you don't need to know the weblogic password.
when you set the defaults hiera variables

    orawls::storeuserconfig{'Wls12c':
      domain_name                => "Wls12c",
      adminserver_address        => "localhost",
      adminserver_port           => 7001,
      weblogic_password          => "weblogic1",
      user_config_dir            => '/home/oracle',
      log_output                 => false,
    }

Same configuration but then with Hiera ( need to have puppet > 3.0 )    
 
    notify { 'class userconfig':} 
    $default_params = {}
    $userconfig_instances = hiera('userconfig_instances', {})
    create_resources('orawls::storeuserconfig',$userconfig_instances, $default_params)
 
vagrantcentos64.example.com.yaml
or when you set the defaults hiera variables


    ---
    userconfig_instances:
      'Wls12c':
         domain_name:          "Wls12c"
         adminserver_address:  "localhost"
         adminserver_port:     7001
         weblogic_password:    "weblogic1"
         log_output:           true
         user_config_dir:      '/home/oracle'


when you just have one WebLogic domain on a server

    #when you just have one domain on a server
    domain_name:                "Wls1036"
    domain_adminserver_address: "localhost"
    domain_adminserver_port:    7001
    domain_wls_password:        "weblogic1"
    
    ---
    userconfig_instances:
      'Wls12c':
         log_output:           true
         user_config_dir:      '/home/oracle'

###fmwlogdir 
__orawls::fmwlogdir__ Change a log folder location of a FMW server  
when you set the defaults hiera variables

    orawls::fmwlogdir{'AdminServer':
      middleware_home_dir    => "/opt/oracle/middleware11gR1",
      weblogic_user          => "weblogic",
      weblogic_password      => "weblogic1",
      os_user                => "oracle",
      os_group               => "dba",
      download_dir           => "/data/install"
      log_dir                => "/var/log/weblogic"
      adminserver_address    => "localhost",
      adminserver_port       => 7001,
      server                 => "AdminServer",
      log_output             => false,
    }

Same configuration but then with Hiera ( need to have puppet > 3.0 )    
 
    $default_params = {}
    $fmwlogdir_instances = hiera('fmwlogdir_instances', {})
    create_resources('orawls::fmwlogdir',$fmwlogdir_instances, $default_params)
 
vagrantcentos64.example.com.yaml
or when you set the defaults hiera variables

    ---
    fmwlogdir_instances:
      'AdminServer':
         log_output:      true
         server:          'AdminServer'



###resourceadapter 
__orawls::resourceadapter__ Add a Resource adapter plan for Aq ,DB or JMS with some entries  
when you set the defaults hiera variables
 
    $default_params = {}
    $resource_adapter_instances = hiera('resource_adapter_instances', {})
    create_resources('orawls::resourceadapter',$resource_adapter_instances, $default_params)
 
vagrantcentos64.example.com.yaml
or when you set the defaults hiera variables

    resource_adapter_instances:
      'JmsAdapter_hr':
        adapter_name:              'JmsAdapter'
        adapter_path:              "/opt/oracle/middleware11g/Oracle_SOA1/soa/connectors/JmsAdapter.rar"
        adapter_plan_dir:          "/opt/oracle/wlsdomains"
        adapter_plan:              'Plan_JMS.xml'
        adapter_entry:             'eis/JMS/cf'
        adapter_entry_property:    'ConnectionFactoryLocation'
        adapter_entry_value:       'jms/cf'
      'AqAdapter_hr':
        adapter_name:              'AqAdapter'
        adapter_path:              "/opt/oracle/middleware11g/Oracle_SOA1/soa/connectors/AqAdapter.rar"
        adapter_plan_dir:          "/opt/oracle/wlsdomains"
        adapter_plan:              'Plan_AQ.xml'
        adapter_entry:             'eis/AQ/hr'
        adapter_entry_property:    'xADataSourceName'
        adapter_entry_value:       'jdbc/hrDS'
      'DbAdapter_hr':
        adapter_name:              'DbAdapter'
        adapter_path:              "/opt/oracle/middleware11g/Oracle_SOA1/soa/connectors/DbAdapter.rar"
        adapter_plan_dir:          "/opt/oracle/wlsdomains"
        adapter_plan:              'Plan_DB.xml'
        adapter_entry:             'eis/DB/hr'
        adapter_entry_property:    'xADataSourceName'
        adapter_entry_value:       'jdbc/hrDS'


###fmwcluster
__orawls::utils::fmwcluster__ convert existing cluster to a osb or soa suite cluster (BPM is optional) and also convert BAM to a BAM cluster  
see this for an example https://github.com/biemond/biemond-orawls-vagrant-solaris-soa  
you need to create a osb, soa or bam cluster with some managed servers first 
for the osb or soa suite managed servers make sure to set the coherence arguments parameters  


    $default_params = {}
    $fmw_cluster_instances = hiera('fmw_cluster_instances', $default_params)
    create_resources('orawls::utils::fmwcluster',$fmw_cluster_instances, $default_params)

hiera configuration

    fmw_cluster_instances:
      'soaCluster':
         domain_dir:           "/opt/oracle/middleware11g/user_projects/domains/soa_basedomain"
         soa_cluster_name:     "SoaCluster"
         bam_cluster_name:     "BamCluster"
         osb_cluster_name:     "OsbCluster"
         log_output:           true
         bpm_enabled:          true
         bam_enabled:          true
         soa_enabled:          true
         osb_enabled:          true

###fmwclusterjrf
__orawls::utils::fmwclusterjrf__ convert existing cluster to a ADF/JRF cluster
you need to create a wls cluster with some managed servers first

    $default_params = {}
    $fmw_jrf_cluster_instances = hiera('fmw_jrf_cluster_instances', $default_params)
    create_resources('orawls::utils::fmwclusterjrf',$fmw_jrf_cluster_instances, $default_params)

hiera configuration

    fmw_jrf_cluster_instances:
      'WebCluster':
         domain_name:          "adf_domain"
         jrf_target_name:      "WebCluster"
         log_output:           *logoutput

###webtier
__orawls::utils::webtier__ add an OHS instance to a WebLogic Domain and in the Enterprise Manager, optional with OHS OAM Webgate

    $default_params = {}
    $webtier_instances = hiera('webtier_instances', {})
    create_resources('orawls::utils::webtier',$webtier_instances, $default_params)

hiera configuration

    # 11g
    webtier_instances:
      'ohs1':
        action_name:           'create'
        instance_name:         'ohs1'
        webgate_configure:     true
        log_output:            *logoutput

    # 12.1.2
      webtier_instances:
        'ohs1':
          action_name:           'create'
          instance_name:         'ohs1'
          machine_name:          'Node1'

###oimconfig
__orawls::utils::oimconfig__ Configure OIM , oim server, design or remote configuration

    $default_params = {}
    $oimconfig_instances = hiera('oimconfig_instances', $default_params)
    create_resources('orawls::utils::oimconfig',$oimconfig_instances, $default_params)

    oimconfig_instances:
      'oimDomain':
        version:                    1112
        oim_home:                   '/opt/oracle/middleware11g/Oracle_IDM1'
        server_config:              true
        oim_password:               'Welcome01'
        remote_config:              false
        keystore_password:          'Welcome01'
        design_config:              false
        oimserver_hostname:         'oim1admin.example.com'
        oimserver_port:             '14000'
        repository_database_url:    "oimdb.example.com:1521:oimrepos.example.com"
        repository_prefix:          "DEV"
        repository_password:        "Welcome01"

###instance
__orawls::oud::instance__ Configure OUD (Oracle Unified Directory) ldap instance

    $default_params = {}
    $oudconfig_instances = hiera('oudconfig_instances', $default_params)
    create_resources('orawls::oud::instance',$oudconfig_instances, $default_params)

    oudconfig_instances:
      'instance1':
        version:                    1112
        oud_home:                   '/opt/oracle/middleware11g/Oracle_OUD1'
        oud_instance_name:          'instance1'
        oud_root_user_password:     'Welcome01'
        oud_baseDN:                 'dc=example,dc=com'
        oud_ldapPort:               1389
        oud_adminConnectorPort:     4444
        oud_ldapsPort:              1636
        log_output:                 *logoutput
      'instance2':
        version:                    1112
        oud_home:                   '/opt/oracle/middleware11g/Oracle_OUD1'
        oud_instance_name:          'instance2'
        oud_root_user_password:     'Welcome01'
        oud_baseDN:                 'dc=example,dc=com'
        oud_ldapPort:               2389
        oud_adminConnectorPort:     5555
        oud_ldapsPort:              2636
        log_output:                 *logoutput

###oud_control
__orawls::oud::control__ Stop or start an OUD (Oracle Unified Directory) ldap instance

    $default_params = {}
    $oud_control_instances = hiera('oud_control_instances', $default_params)
    create_resources('orawls::oud::control',$oud_control_instances, $default_params)

    oud_control_instances:
      'instance1':
        oud_instances_home_dir:     '/opt/oracle/oud_instances' 
        oud_instance_name:          'instance1'
        action:                     'start'
        log_output:                 *logoutput

##Types and providers

All wls types needs a wls_setting definition, this is a pointer to an WebLogic AdminServer and you need to create one for every WebLogic domain. When you don't provide a wls_setting identifier in the title of the weblogic type then it will use default as identifier.

###wls_setting

required for all the weblogic type/providers, this is a pointer to an WebLogic AdminServer.

      wls_setting { 'default':
        user               => 'oracle',
        weblogic_home_dir  => '/opt/oracle/middleware11g/wlserver_10.3',
        connect_url        => "t3://localhost:7001",
        weblogic_user      => 'weblogic',
        weblogic_password  => 'weblogic1',
      }

      wls_setting { 'domain2':
        user               => 'oracle',
        weblogic_home_dir  => '/opt/oracle/middleware11g/wlserver_10.3',
        connect_url        => "t3://localhost:7011",
        weblogic_user      => 'weblogic',
        weblogic_password  => 'weblogic1',
        post_classpath:     "/opt/oracle/wlsdomains/domains/Wls1036/lib/aa.jar"
      }

###wls_domain

it needs wls_setting and when identifier is not provided it will use the 'default'. Probably after changing the domain you need to restart the AdminServer or subscribe for a restart to this change with the wls_adminserver type

or use puppet resource wls_domain

    # In this case it will use default as wls_setting identifier
    wls_domain { 'Wls1036':
      ensure                      => 'present',
      jpa_default_provider        => 'org.eclipse.persistence.jpa.PersistenceProvider',
      jta_max_transactions        => '20000',
      jta_transaction_timeout     => '35',
      log_file_min_size           => '5000',
      log_filecount               => '5',
      log_filename                => '/var/log/weblogic/Wls1036.log',
      log_number_of_files_limited => '1',
      log_rotate_logon_startup    => '1',
      log_rotationtype            => 'bySize',
      security_crossdomain        => '0',
    }
    # In this case it will use domain2 as wls_setting identifier
    wls_domain { 'domain2/Wls11g':
      ensure                      => 'present',
      jpa_default_provider        => 'org.apache.openjpa.persistence.PersistenceProviderImpl',
      jta_max_transactions        => '10000',
      jta_transaction_timeout     => '30',
      log_file_min_size           => '5000',
      log_filecount               => '10',
      log_filename                => '/var/log/weblogic/Wls11g.log',
      log_number_of_files_limited => '0',
      log_rotate_logon_startup    => '0',
      log_rotationtype            => 'byTime',
      security_crossdomain        => '1',
    }

in hiera

    require userconfig
    $default_params = {}
    $wls_domain_instances = hiera('wls_domain_instances', {})
    create_resources('wls_domain',$wls_domain_instances, $default_params)

    # 'Wls1036' will use default as wls_setting identifier
    # 'Wls11g' will use domain2 as wls_setting identifier
    wls_domain_instances:
      'Wls1036':      
        ensure:                      'present'
        jpa_default_provider:        'org.eclipse.persistence.jpa.PersistenceProvider'
        jta_max_transactions:        '20000'
        jta_transaction_timeout:     '35'
        log_file_min_size:           '5000'
        log_filecount:               '5'
        log_filename:                '/var/log/weblogic/Wls1036.log'
        log_number_of_files_limited: '1'
        log_rotate_logon_startup:    '1'
        log_rotationtype:            'bySize'
        security_crossdomain:        '0'
      'domain2/Wls11g':
        ensure:                      'present'
        jpa_default_provider:        'org.apache.openjpa.persistence.PersistenceProviderImpl'
        jta_max_transactions:        '10000'
        jta_transaction_timeout:     '30'
        log_file_min_size:           '5000'
        log_filecount:               '10'
        log_filename:                '/var/log/weblogic/Wls11g.log'
        log_number_of_files_limited: '0'
        log_rotate_logon_startup:    '0'
        log_rotationtype:            'byTime'
        security_crossdomain:        '1'


###wls_adminserver

type for adminserver control like start, running, abort and stop.  
also supports subscribe with refreshonly


    # for this type you won't need a wls_setting identifier
    wls_adminserver{'AdminServer_Wls1036:':
      ensure                    => 'running',   #running|start|abort|stop 
      server_name               => hiera('domain_adminserver'),
      domain_name               => hiera('domain_name'),
      domain_path               => "/opt/oracle/wlsdomains/domains/Wls1036",
      os_user                   => hiera('wls_os_user'),
      weblogic_home_dir         => hiera('wls_weblogic_home_dir'),
      weblogic_user             => hiera('wls_weblogic_user'),
      weblogic_password         => hiera('domain_wls_password'),
      jdk_home_dir              => hiera('wls_jdk_home_dir'),
      nodemanager_address       => hiera('domain_adminserver_address'),
      nodemanager_port          => hiera('domain_nodemanager_port'),
      jsse_enabled              => false,
      custom_trust              => false,
    }

with JSSE and custom trust

    # for this type you won't need a wls_setting identifier
    wls_adminserver{'AdminServer_Wls1036:':
      ensure                    => 'running',   #running|start|abort|stop 
      server_name               => hiera('domain_adminserver'),
      domain_name               => hiera('domain_name'),
      domain_path               => "/opt/oracle/wlsdomains/domains/Wls1036",
      os_user                   => hiera('wls_os_user'),
      weblogic_home_dir         => hiera('wls_weblogic_home_dir'),
      weblogic_user             => hiera('wls_weblogic_user'),
      weblogic_password         => hiera('domain_wls_password'),
      jdk_home_dir              => hiera('wls_jdk_home_dir'),
      nodemanager_address       => hiera('domain_adminserver_address'),
      nodemanager_port          => hiera('domain_nodemanager_port'),
      jsse_enabled              => hiera('wls_jsse_enabled'),
      custom_trust              => hiera('wls_custom_trust'),
      trust_keystore_file       => hiera('wls_trust_keystore_file'),
      trust_keystore_passphrase => hiera('wls_trust_keystore_passphrase'),
    }

subscribe to a wls_domain or wls_authenticaton_provider event 

    # for this type you won't need a wls_setting identifier
    wls_adminserver{'AdminServer_Wls1036:':
      ensure                    => 'running',   #running|start|abort|stop 
      server_name               => hiera('domain_adminserver'),
      domain_name               => hiera('domain_name'),
      domain_path               => "/opt/oracle/wlsdomains/domains/Wls1036",
      os_user                   => hiera('wls_os_user'),
      weblogic_home_dir         => hiera('wls_weblogic_home_dir'),
      weblogic_user             => hiera('wls_weblogic_user'),
      weblogic_password         => hiera('domain_wls_password'),
      jdk_home_dir              => hiera('wls_jdk_home_dir'),
      nodemanager_address       => hiera('domain_adminserver_address'),
      nodemanager_port          => hiera('domain_nodemanager_port'),
      jsse_enabled              => hiera('wls_jsse_enabled'),
      custom_trust              => hiera('wls_custom_trust'),
      trust_keystore_file       => hiera('wls_trust_keystore_file'),
      trust_keystore_passphrase => hiera('wls_trust_keystore_passphrase'),
      refreshonly               => true,
      subscribe                 => Wls_domain['Wls1036'],
    }

###wls_managedserver

type for managed server control like start, running, abort and stop a managed server or a cluster.  
also supports subscribe with refreshonly


    # for this type you won't need a wls_setting identifier
    wls_managedserver{'JMSServer1_Wls1036:':
      ensure                    => 'running',   #running|start|abort|stop 
      target                    => 'Server', #Server|Cluster
      server_name               => 'JMSServer1',
      domain_name               => hiera('domain_name'),
      os_user                   => hiera('wls_os_user'),
      weblogic_home_dir         => hiera('wls_weblogic_home_dir'),
      weblogic_user             => hiera('wls_weblogic_user'),
      weblogic_password         => hiera('domain_wls_password'),
      jdk_home_dir              => hiera('wls_jdk_home_dir'),
      adminserver_address       => hiera('domain_adminserver_address'),
      adminserver_port          => hiera('domain_adminserver_port'),
    }


subscribe to a wls_domain or wls_authenticaton_provider event 

    # for this type you won't need a wls_setting identifier
    wls_managedserver{'JMSServer1_Wls1036':
      ensure                    => 'running',   #running|start|abort|stop 
      target                    => 'Server',    #Server|Cluster
      server_name               => 'JMSServer1',
      domain_name               => hiera('domain_name'),
      os_user                   => hiera('wls_os_user'),
      weblogic_home_dir         => hiera('wls_weblogic_home_dir'),
      weblogic_user             => hiera('wls_weblogic_user'),
      weblogic_password         => hiera('domain_wls_password'),
      jdk_home_dir              => hiera('wls_jdk_home_dir'),
      adminserver_address       => hiera('domain_adminserver_address'),
      adminserver_port          => hiera('domain_adminserver_port'),
      refreshonly               => true,
      subscribe                 => Wls_domain['Wls1036'],
    }


###wls_deployment

it needs wls_setting and when identifier is not provided it will use the 'default'.  
or use puppet resource wls_deployment


    # 'jersey-bundle' will use default as wls_setting identifier
    wls_deployment { 'jersey-bundle':
      ensure            => 'present',
      deploymenttype    => 'Library',
      target            => ['AdminServer','WebCluster'],
      targettype        => ['Server','Cluster'],
      versionidentifier => '1.18@1.18.0.0',
      localpath         =>  '/vagrant/jersey-bundle-1.18.war',
    }
    # this will use default as wls_setting identifier
    wls_deployment { 'webapp':
      ensure            => 'present',
      deploymenttype    => 'AppDeployment',
      target            => ['WebCluster'],
      targettype        => ['Cluster'],
      localpath         => '/vagrant/webapp.war',
    }

or add a version

    # this will use default as wls_setting identifier
    wls_deployment { 'webapp':
      ensure            => 'present',
      deploymenttype    => 'AppDeployment',
      target            => ['WebCluster'],
      targettype        => ['Cluster'],
      versionidentifier => '1.1@1.1.0.0',
      localpath         => '/vagrant/webapp.war',
    }


in hiera

    $default_params = {}
    $deployment_instances = hiera('deployment_library_instances', $default_params)
    create_resources('wls_deployment',$deployment_instances, $default_params)

    # this will use default as wls_setting identifier
    deployment_library_instances:
      'jersey-bundle':
        ensure:            'present'
        deploymenttype:    'Library'
        versionidentifier: '1.18@1.18.0.0'
        target:            
          - 'AdminServer'
          - 'WebCluster'
        targettype:        
          - 'Server'
          - 'Cluster'
        localpath:         '/vagrant/jersey-bundle-1.18.war'

    $default_params = {}
    $deployment_instances = hiera('deployment_application_instances', $default_params)
    create_resources('wls_deployment',$deployment_instances, $default_params)

    # this will use default as wls_setting identifier
    deployment_application_instances:
      'webapp':
        ensure:            'present'
        deploymenttype:    'AppDeployment'
        versionidentifier: '1.1@1.1.0.0'
        target:            
          - 'AdminServer'
          - 'WebCluster'
        targettype:        
          - 'Server'
          - 'Cluster'
        localpath:         '/vagrant/webapp.war'


###wls_user

it needs wls_setting and when identifier is not provided it will use the 'default'.  

or use puppet resource wls_user

    # this will use default as wls_setting identifier
    wls_user { 'OracleSystemUser':
      ensure                 => 'present',
      authenticationprovider => 'DefaultAuthenticator',
      description            => 'Oracle application software system user.',
      realm                  => 'myrealm',
    }
    # this will use default as wls_setting identifier
    wls_user { 'default/testuser1':
      ensure                 => 'present',
      authenticationprovider => 'DefaultAuthenticator',
      description            => 'testuser1',
      realm                  => 'myrealm',
    }
    # this will use domain2 as wls_setting identifier
    wls_user { 'domain2/testuser1':
      ensure                 => 'present',
      authenticationprovider => 'DefaultAuthenticator',
      description            => 'testuser1',
      realm                  => 'myrealm',
    }


in hiera

    $default_params = {}
    $user_instances = hiera('user_instances', {})
    create_resources('wls_user',$user_instances, $default_params)

    # testuser1 will use default as wls_setting identifier
    # testuser2 will use domain2 as wls_setting identifier
    user_instances:
      'testuser1':
        ensure:                 'present'
        password:               'weblogic1'
        authenticationprovider: 'DefaultAuthenticator'
        realm:                  'myrealm'
        description:            'my test user'
      'domain2/testuser2':
        ensure:                 'present'
        password:               'weblogic1'
        authenticationprovider: 'DefaultAuthenticator'
        realm:                  'myrealm'
        description:            'my test user'

###wls_group

it needs wls_setting and when identifier is not provided it will use the 'default'.  

or use puppet resource wls_group

    # this will use default as wls_setting identifier
    wls_group { 'SuperUsers':
      ensure                 => 'present',
      authenticationprovider => 'DefaultAuthenticator',
      description            => 'SuperUsers',
      realm                  => 'myrealm',
      users                  => ['testuser2'],
    }
    # this will use default as wls_setting identifier
    wls_group { 'TestGroup':
      ensure                 => 'present',
      authenticationprovider => 'DefaultAuthenticator',
      description            => 'TestGroup',
      realm                  => 'myrealm',
      users                  => ['testuser1','testuser2'],
    }

in hiera

    $default_params = {}
    $group_instances = hiera('group_instances', {})
    create_resources('wls_group',$group_instances, $default_params)

    # this will use default as wls_setting identifier
    group_instances:
      'TestGroup':
        ensure:                 'present'
        authenticationprovider: 'DefaultAuthenticator'
        description:            'TestGroup'
        realm:                  'myrealm'
        users:                  
          - 'testuser1'
          - 'testuser2'
      'SuperUsers':
        ensure:                 'present'
        authenticationprovider: 'DefaultAuthenticator'
        description:            'SuperUsers'
        realm:                  'myrealm'
        users:                  
          - 'testuser2'

###wls_authentication_provider

it needs wls_setting and when identifier is not provided it will use the 'default' and probably after the creation the AdminServer needs a reboot or subscribe to a restart with the wls_adminserver type

only control_flag is a property, the rest are parameters and only used in a create action

or use puppet resource wls_authentication_provider


    # this will use default as wls_setting identifier
    wls_authentication_provider { 'DefaultAuthenticator':
      ensure       => 'present',
      control_flag => 'SUFFICIENT',
    }
    # this will use default as wls_setting identifier
    wls_authentication_provider { 'ldap':
      ensure            => 'present',
      control_flag      => 'SUFFICIENT',
      providerclassname => 'weblogic.security.providers.authentication.LDAPAuthenticator',
      attributes:       =>  'Principal;Host;Port;CacheTTL;CacheSize;MaxGroupMembershipSearchLevel;SSLEnabled',
      attributesvalues  =>  'ldapuser;ldapserver;389;60;1024;4;true',
    }


in hiera

    $default_params = {}
    $authentication_provider_instances = hiera('authentication_provider_instances', {})
    create_resources('wls_authentication_provider',$authentication_provider_instances, $default_params)


    # this will use default as wls_setting identifier
    authentication_provider_instances:
      'DefaultAuthenticator':
        ensure:             'present'
        control_flag:       'SUFFICIENT'
      'ldap':
        ensure:             'present'
        control_flag:       'SUFFICIENT'
        providerclassname:  'weblogic.security.providers.authentication.LDAPAuthenticator'
        attributes:         'Principal,Host,Port,CacheTTL,CacheSize,MaxGroupMembershipSearchLevel,SSLEnabled'
        attributesvalues:   'ldapuser,ldapserver,389,60,1024,4,true'



###wls_machine

it needs wls_setting and when identifier is not provided it will use the 'default'.  

or use puppet resource wls_machine

    # this will use default as wls_setting identifier
    wls_machine { 'test2':
      ensure        => 'present',
      listenaddress => '10.10.10.10',
      listenport    => '5556',
      machinetype   => 'UnixMachine',
      nmtype        => 'SSL',
    }
    # this will use domain2 as wls_setting identifier
    wls_machine { 'domain2/test2':
      ensure        => 'present',
      listenaddress => '10.10.10.10',
      listenport    => '5556',
      machinetype   => 'UnixMachine',
      nmtype        => 'SSL',
    }


in hiera

    # Node1 will use default as wls_setting identifier
    # Node2 will use domain2 as wls_setting identifier
    machines_instances:
      'Node1':
        ensure:         'present'
        listenaddress:  '10.10.10.100'
        listenport:     '5556'
        machinetype:    'UnixMachine'
        nmtype:         'SSL'
      'domain2/Node2':
        ensure:         'present'
        listenaddress:  '10.10.10.200'
        listenport:     '5556'
        machinetype:    'UnixMachine'
        nmtype:         'SSL'


###wls_server

it needs wls_setting and when identifier is not provided it will use the 'default'.  

or use puppet resource wls_server

    # this will use default as wls_setting identifier
    wls_server { 'wlsServer1':
      ensure                            => 'present',
      arguments                         => '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer1.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer1_err.out',
      jsseenabled                       => '0',
      listenaddress                     => '10.10.10.100',
      listenport                        => '8001',
      machine                           => 'Node1',
      sslenabled                        => '0',
    }

or with log parameters and ssl

    # this will use default as wls_setting identifier
    wls_server { 'default/wlsServer2':
      ensure                            => 'present',
      arguments                         => '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer2.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer2_err.out',
      jsseenabled                       => '0',
      listenaddress                     => '10.10.10.200',
      listenport                        => '8001',
      log_file_min_size                 => '2000',
      log_filecount                     => '10',
      log_number_of_files_limited       => '1',
      log_rotate_logon_startup          => '1',
      log_rotationtype                  => 'bySize',
      logfilename                       => '/var/log/weblogic/wlsServer2.log',
      machine                           => 'Node2',
      sslenabled                        => '1',
      sslhostnameverificationignored    => '1',
      ssllistenport                     => '8201',
    }

or with JSSE with custom identity and trust

    # this will use domain2 as wls_setting identifier
    wls_server { 'domain2/wlsServer2':
      ensure                                => 'present',
      arguments                             => '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer2.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer2_err.out',
      listenaddress                         => '10.10.10.200',
      listenport                            => '8001',
      log_file_min_size                     => '2000',
      log_filecount                         => '10',
      log_number_of_files_limited           => '1',
      log_rotate_logon_startup              => '1',
      log_rotationtype                      => 'bySize',
      logfilename                           => '/var/log/weblogic/wlsServer2.log',
      machine                               => 'Node2',
      sslenabled                            => '1',
      sslhostnameverificationignored        => '1',
      ssllistenport                         => '8201',
      jsseenabled                           => '1',
      custom_identity                       => '1',
      custom_identity_alias                 => 'node2',
      custom_identity_keystore_filename     => '/vagrant/identity_node2.jks',
      custom_identity_keystore_passphrase   => 'welcome',
      custom_identity_privatekey_passphrase => 'welcome',
      trust_keystore_file                   => '/vagrant/truststore.jks',
      trust_keystore_passphrase             => 'welcome',
    }


in hiera

    # this will use default as wls_setting identifier
    server_instances:
      'wlsServer1':
         ensure:                         'present'
         arguments:                      '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer1.out -Dweblogic.Stderr=/data/logs/wlsServer1_err.out'
         listenaddress:                  '10.10.10.100'
         listenport:                     '8001'
         logfilename:                    '/data/logs/wlsServer1.log'
         machine:                        'Node1'
         sslenabled:                     '1'
         jsseenabled:                    '0'
         ssllistenport:                  '8201'
         sslhostnameverificationignored: '1'

or with log parameters

    # this will use default as wls_setting identifier
    server_instances:
      'wlsServer1':
        ensure:                         'present'
        arguments:                      '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer1.out -Dweblogic.Stderr=/data/logs/wlsServer1_err.out'
        listenaddress:                         '10.10.10.100'
        listenport:                            '8001'
        logfilename:                           '/var/log/weblogic/wlsServer1.log'
        log_file_min_size:                     '2000'
        log_filecount:                         '10'
        log_number_of_files_limited:           '1'
        log_rotate_logon_startup:              '1'
        log_rotationtype:                      'bySize'
        machine:                               'Node1'
        sslenabled:                            '1'
        ssllistenport:                         '8201'
        sslhostnameverificationignored:        '1'
        jsseenabled:                           '1' 


You can also pass server arguments as an array, as it makes it easier to use references in YAML.

    server_vm_args_permsize:      &server_vm_args_permsize     '-XX:PermSize=256m' 
    server_vm_args_max_permsize:  &server_vm_args_max_permsize '-XX:MaxPermSize=256m' 
    server_vm_args_memory:        &server_vm_args_memory       '-Xms752m' 
    server_vm_args_max_memory:    &server_vm_args_max_memory   '-Xmx752m' 

    # this will use default as wls_setting identifier
    server_instances:
      'wlsServer1':
        ensure:                                'present'
        arguments:
               - *server_vm_args_permsize
               - *server_vm_args_max_permsize
               - *server_vm_args_memory
               - *server_vm_args_max_memory
               - '-Dweblogic.Stdout=/var/log/weblogic/wlsServer1.out'
               - '-Dweblogic.Stderr=/var/log/weblogic/wlsServer1_err.out'
        listenaddress:                         '10.10.10.100'
        listenport:                            '8001'
        logfilename:                           '/var/log/weblogic/wlsServer1.log'
        machine:                               'Node1'
        sslenabled:                            '1'
        ssllistenport:                         '8201'
        sslhostnameverificationignored:        '1'
        jsseenabled:                           '1' 
      'wlsServer2':
        ensure:                                'present'
        arguments:
               - *server_vm_args_permsize
               - *server_vm_args_max_permsize
               - *server_vm_args_memory
               - *server_vm_args_max_memory
               - '-Dweblogic.Stdout=/var/log/weblogic/wlsServer2.out'
               - '-Dweblogic.Stderr=/var/log/weblogic/wlsServer2_err.out'
        listenport:                            '8001'
        logfilename:                           '/var/log/weblogic/wlsServer2.log'
        machine:                               'Node2'
        sslenabled:                            '1'
        ssllistenport:                         '8201'
        sslhostnameverificationignored:        '1'
        listenaddress:                         '10.10.10.200'
        jsseenabled:                           '1' 

or with custom identity and custom truststore

    # used by nodemanager, control and domain creation
    wls_custom_trust:                  &wls_custom_trust              true
    wls_trust_keystore_file:           &wls_trust_keystore_file       '/vagrant/truststore.jks'
    wls_trust_keystore_passphrase:     &wls_trust_keystore_passphrase 'welcome'


    # this will use default as wls_setting identifier
    server_instances:
      'wlsServer1':
        ensure:                                'present'
        arguments:                             '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer1.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer1_err.out'
        listenaddress:                         '10.10.10.100'
        listenport:                            '8001'
        logfilename:                           '/var/log/weblogic/wlsServer1.log'
        machine:                               'Node1'
        sslenabled:                            '1'
        ssllistenport:                         '8201'
        sslhostnameverificationignored:        '1'
        jsseenabled:                           '1' 
        custom_identity:                       '1'
        custom_identity_keystore_filename:     '/vagrant/identity_node1.jks'
        custom_identity_keystore_passphrase:   'welcome'
        custom_identity_alias:                 'node1'
        custom_identity_privatekey_passphrase: 'welcome'
        trust_keystore_file:                   *wls_trust_keystore_file
        trust_keystore_passphrase:             *wls_trust_keystore_passphrase

 
###wls_server_channel

it needs wls_setting and when identifier is not provided it will use the 'default', the title must also contain the server name    

or use puppet resource wls_server_channel

    # this will use default as wls_setting identifier
    wls_server_channel { 'wlsServer1:Channel-Cluster':
      ensure           => 'present',
      enabled          => '1',
      httpenabled      => '1',
      listenaddress    => '10.10.10.100',
      listenport       => '8003',
      outboundenabled  => '0',
      protocol         => 'cluster-broadcast',
      publicaddress    => '10.10.10.100',
      tunnelingenabled => '0',
    }
    # this will use default as wls_setting identifier
    wls_server_channel { 'wlsServer2:Channel-Cluster':
      ensure           => 'present',
      enabled          => '1',
      httpenabled      => '1',
      listenport       => '8003',
      outboundenabled  => '0',
      protocol         => 'cluster-broadcast',
      tunnelingenabled => '0',
    }

in hiera

    # this will use default as wls_setting identifier
    server_channel_instances:
      'wlsServer1:Channel-Cluster':
        ensure:           'present'
        enabled:          '1'
        httpenabled:      '1'
        listenaddress:    '10.10.10.100'
        listenport:       '8003'
        outboundenabled:  '0'
        protocol:         'cluster-broadcast'
        publicaddress:    '10.10.10.100'
        tunnelingenabled: '0'
      'wlsServer2:Channel-Cluster':
        ensure:           'present'
        enabled:          '1'
        httpenabled:      '1'
        listenport:       '8003'
        outboundenabled:  '0'
        protocol:         'cluster-broadcast'
        tunnelingenabled: '0'    


###wls_cluster

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_cluster

    # this will use default as wls_setting identifier
    wls_cluster { 'WebCluster':
      ensure           => 'present',
      messagingmode    => 'unicast',
      migrationbasis   => 'consensus',
      servers          => ['wlsServer3','wlsServer4'],
      multicastaddress => '239.192.0.0',
      multicastport    => '7001',
    }
    # this will use default as wls_setting identifier
    wls_cluster { 'WebCluster2':
      ensure                  => 'present',
      messagingmode           => 'unicast',
      migrationbasis          => 'consensus',
      servers                 => ['wlsServer3','wlsServer4'],
      unicastbroadcastchannel => 'channel',
      multicastaddress        => '239.192.0.0',
      multicastport           => '7001',
    }

in hiera

    # this will use default as wls_setting identifier
    cluster_instances:
      'WebCluster':
        ensure:         'present'
        messagingmode:  'unicast'
        migrationbasis: 'consensus'
        servers:
          - 'wlsServer1'
          - 'wlsServer2'

###wls_virtual_host

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_virtual_host

    # this will use default as wls_setting identifier
    wls_virtual_host { 'default/WS':
      ensure             => 'present',
      channel            => 'HTTP',
      target             => ['WebCluster'],
      targettype         => ['Cluster'],
      virtual_host_names => ['admin.example.com','10.10.10.10'],
    }

in hiera

    # this will use default as wls_setting identifier
    virtual_host_instances:
     'WS':
       ensure:     'present'
       channel:    'HTTP'
       target:
         - 'WebCluster'
       targettype:
         - 'Cluster'
       virtual_host_names: 
         - 'admin.example.com'
         - '10.10.10.10'

###wls_workmanager_constaint

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_workmanager_constaint

    # this will use default as wls_setting identifier
    wls_workmanager_constraint { 'default/CapacityConstraint':
      ensure          => 'present',
      constrainttype  => 'Capacity',
      constraintvalue => '20',
      target          => ['WebCluster'],
      targettype      => ['Cluster'],
    }
    # this will use default as wls_setting identifier
    wls_workmanager_constraint { 'default/MaxThreadsConstraint':
      ensure          => 'present',
      constrainttype  => 'MaxThreadsConstraint',
      constraintvalue => '5',
      target          => ['WebCluster'],
      targettype      => ['Cluster'],
    }
    # this will use default as wls_setting identifier
    wls_workmanager_constraint { 'default/MinThreadsConstraint':
      ensure          => 'present',
      constrainttype  => 'MinThreadsConstraint',
      constraintvalue => '2',
      target          => ['WebCluster'],
      targettype      => ['Cluster'],
    }

in hiera

    # this will use default as wls_setting identifier
    workmanager_constraint_instances:
      'CapacityConstraint':
        ensure:          'present'
        constraintvalue: '20'
        target:          
          - 'WebCluster'
        targettype:      
          - 'Cluster'
        constrainttype:  'Capacity'
      'MaxThreadsConstraint':
        ensure:          'present'
        constraintvalue: '5'
        target:          
          - 'WebCluster'
        targettype:      
          - 'Cluster'
        constrainttype:  'MaxThreadsConstraint'
      'MinThreadsConstraint':
        ensure:          'present'
        constraintvalue: '2'
        target:          
          - 'WebCluster'
        targettype:      
          - 'Cluster'
        constrainttype:  'MinThreadsConstraint'

###wls_workmanager

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_workmanager

    # this will use default as wls_setting identifier
    wls_workmanager { 'WorkManagerConstraints':
      ensure               => 'present',
      capacity             => 'CapacityConstraint',
      maxthreadsconstraint => 'MaxThreadsConstraint',
      minthreadsconstraint => 'MinThreadsConstraint',
      stuckthreads         => '0',
      target               => ['WebCluster'],
      targettype           => ['Cluster'],
    }

in hiera

    # this will use default as wls_setting identifier
    workmanager_instances:
      'WorkManagerConstraints':
        ensure:                'present'
        capacity:              'CapacityConstraint'
        maxthreadsconstraint:  'MaxThreadsConstraint'
        minthreadsconstraint:  'MinThreadsConstraint'
        stuckthreads:          '1'
        target:                
          - 'WebCluster'
        targettype:            
          - 'Cluster'



###wls_file_persistence_store

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_file_persistence_store

    # this will use default as wls_setting identifier
    wls_file_persistence_store { 'jmsFile1':
      ensure     => 'present',
      directory  => 'persistence1',
      target     => ['wlsServer1'],
      targettype => ['Server'],
    }
    # this will use default as wls_setting identifier
    wls_file_persistence_store { 'jmsFile2':
      ensure     => 'present',
      directory  => 'persistence2',
      target     => ['wlsServer2'],
      targettype => ['Server'],
    }
    # this will use default as wls_setting identifier
    wls_file_persistence_store { 'jmsFileSAFAgent1':
      ensure     => 'present',
      directory  => 'persistenceSaf1',
      target     => ['wlsServer1'],
      targettype => ['Server'],
    }

in hiera

    # this will use default as wls_setting identifier
    file_persistence_store_instances:
      'jmsFile1':
        ensure:         'present'
        directory:      'persistence1'
        target:         
         - 'wlsServer1'
        targettype:     
         - 'Server'
      'jmsFile2':
        ensure:         'present'
        directory:      'persistence2'
        target:         
         - 'wlsServer2'
        targettype:     
         - 'Server'
      'jmsFileSAFAgent1':
        ensure:         'present'
        directory:      'persistenceSaf1'
        target:         
         - 'wlsServer1'
        targettype:     
         - 'Server'


###wls_safagent

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_safagent


    # this will use default as wls_setting identifier
    wls_safagent { 'jmsSAFAgent1':
      ensure              => 'present',
      persistentstore     => 'jmsFileSAFAgent1',
      persistentstoretype => 'FileStore',
      servicetype         => 'Sending-only',
      target              => ['wlsServer1'],
      targettype          => ['Server'],
    }
    # this will use default as wls_setting identifier
    wls_safagent { 'jmsSAFAgent2':
      ensure      => 'present',
      servicetype => 'Both',
      target      => ['wlsServer2'],
      targettype  => ['Server'],
    }

in hiera

    # this will use default as wls_setting identifier
    safagent_instances:
      'jmsSAFAgent1':
            ensure:              'present'
            target:              
              - 'wlsServer1'
            targettype:          
              - 'Server'
            servicetype:         'Sending-only'
            persistentstore:     'jmsFileSAFAgent1'
            persistentstoretype: 'FileStore'
      'jmsSAFAgent2':
            ensure:              'present'
            target:              
              - 'wlsServer2'
            targettype:          
              - 'Server'
            servicetype:         'Both'


###wls_jmsserver

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_jmsserver

    # this will use default as wls_setting identifier
    wls_jmsserver { 'jmsServer1':
      ensure              => 'present',
      persistentstore     => 'jmsFile1',
      persistentstoretype => 'FileStore',
      target              => ['wlsServer1'],
      targettype          => ['Server'],
    }
    # this will use default as wls_setting identifier
    wls_jmsserver { 'jmsServer2':
      ensure     => 'present',
      target     => ['wlsServer2'],
      targettype => ['Server'],
    }
    # this will use default as wls_setting identifier
    wls_jmsserver { 'jmsServer3':
      ensure     => 'present',
      target     => ['wlsServer3'],
      targettype => ['Server'],
    }


in hiera

    # this will use default as wls_setting identifier
    jmsserver_instances:
       jmsServer1:
         ensure:              'present'
         target:              
           - 'wlsServer1'
         targettype:          
           - 'Server'
         persistentstore:     'jmsFile1'
         persistentstoretype: 'FileStore'
       jmsServer2:
         ensure:              'present'
         target:              
           - 'wlsServer2'
         targettype:          
           - 'Server'


###wls_datasource

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_datasource

    # this will use default as wls_setting identifier
    wls_datasource { 'hrDS':
      ensure                     => 'present',
      drivername                 => 'oracle.jdbc.xa.client.OracleXADataSource',
      extraproperties            => ['SendStreamAsBlob','oracle.net.CONNECT_TIMEOUT'],
      extrapropertiesvalues      => ['true','10000'],
      globaltransactionsprotocol => 'TwoPhaseCommit',
      initialcapacity            => '1',
      jndinames                  => ['jdbc/hrDS'],
      maxcapacity                => '15',
      target                     => ['WebCluster','WebCluster2'],
      targettype                 => ['Cluster','Cluster'],
      testtablename              => 'SQL SELECT 1 FROM DUAL',
      url                        => 'jdbc:oracle:thin:@dbagent2.alfa.local:1521/test.oracle.com',
      user                       => 'hr',
      usexa                      => '1',
    }
    # this will use default as wls_setting identifier
    wls_datasource { 'jmsDS':
      ensure                     => 'present',
      drivername                 => 'com.mysql.jdbc.Driver',
      globaltransactionsprotocol => 'None',
      initialcapacity            => '1',
      jndinames                  => ['jmsDS'],
      maxcapacity                => '15',
      target                     => ['WebCluster'],
      targettype                 => ['Cluster'],
      testtablename              => 'SQL SELECT 1',
      url                        => 'jdbc:mysql://10.10.10.10:3306/jms',
      user                       => 'jms',
      usexa                      => '1',
    }

in hiera


    # this will use default as wls_setting identifier
    datasource_instances:
        'hrDS':
          ensure:                      'present'
          drivername:                  'oracle.jdbc.xa.client.OracleXADataSource'
          extraproperties:             
            - 'SendStreamAsBlob'
            - 'oracle.net.CONNECT_TIMEOUT'
          extrapropertiesvalues:       
            - 'true'
            - '10000'
          globaltransactionsprotocol:  'TwoPhaseCommit'
          initialcapacity:             '1'
          jndinames:                   
           - 'jdbc/hrDS'
          maxcapacity:                 '15'
          target:                      
            - 'WebCluster'
            - 'WebCluster2'
          targettype:                  
            - 'Cluster'
            - 'Cluster'
          testtablename:               'SQL SELECT 1 FROM DUAL'
          url:                         "jdbc:oracle:thin:@dbagent2.alfa.local:1521/test.oracle.com"
          user:                        'hr'
          usexa:                       '1'
        'jmsDS':
          ensure:                      'present'
          drivername:                  'com.mysql.jdbc.Driver'
          globaltransactionsprotocol:  'None'
          initialcapacity:             '1'
          jndinames:                   
            - 'jmsDS'
          maxcapacity:                 '15'
          target:                      
           - 'WebCluster'
          targettype:                  
           - 'Cluster'
          testtablename:               'SQL SELECT 1'
          url:                         'jdbc:mysql://10.10.10.10:3306/jms'
          user:                        'jms'
          usexa:                       '1'


###wls_jms_module

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_jms_module

    # this will use default as wls_setting identifier
    wls_jms_module { 'jmsClusterModule':
      ensure     => 'present',
      target     => ['WebCluster'],
      targettype => ['Cluster'],
    }

in hiera

    # this will use default as wls_setting identifier
    jms_module_instances:
       jmsClusterModule:
         ensure:      'present'
         target:      
           - 'WebCluster'
         targettype:  
           - 'Cluster'


###wls_connection_factory

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name  

or use puppet resource wls_connection_factory

    wls_jms_connection_factory { 'jmsClusterModule:cf':
      ensure             => 'present',
      defaulttargeting   => '0',
      jndiname           => 'jms/cf',
      subdeployment      => 'wlsServers',
      transactiontimeout => '3600',
      xaenabled          => '0',
    }
    wls_jms_connection_factory { 'jmsClusterModule:cf2':
      ensure             => 'present',
      defaulttargeting   => '1',
      jndiname           => 'jms/cf2',
      subdeployment      => 'cf2',
      transactiontimeout => '3600',
      xaenabled          => '1',
    }

in hiera

    jms_connection_factory_instances:
      'jmsClusterModule:cf':
          ensure:             'present'
          jmsmodule:          'jmsClusterModule'
          defaulttargeting:   '0'
          jndiname:           'jms/cf'
          subdeployment:      'wlsServers'
          transactiontimeout: '3600'
          xaenabled:          '0'
      'jmsClusterModule:cf2':
          ensure:             'present'
          jmsmodule:          'jmsClusterModule'
          defaulttargeting:   '1'
          jndiname:           'jms/cf2'
          transactiontimeout: '3600'
          xaenabled:          '1'

###wls_jms_queue

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name  

or use puppet resource wls_jms_queue

    wls_jms_queue { 'jmsClusterModule:ErrorQueue':
      ensure           => 'present',
      defaulttargeting => '0',
      distributed      => '1',
      expirationpolicy => 'Discard',
      jndiname         => 'jms/ErrorQueue',
      redeliverydelay  => '-1',
      redeliverylimit  => '-1',
      subdeployment    => 'jmsServers',
      timetodeliver    => '-1',
      timetolive       => '-1',
    }
    wls_jms_queue { 'jmsClusterModule:Queue1':
      ensure           => 'present',
      defaulttargeting => '0',
      distributed      => '1',
      errordestination => 'ErrorQueue',
      expirationpolicy => 'Redirect',
      jndiname         => 'jms/Queue1',
      redeliverydelay  => '2000',
      redeliverylimit  => '3',
      subdeployment    => 'jmsServers',
      timetodeliver    => '-1',
      timetolive       => '300000',
    }
    wls_jms_queue { 'jmsClusterModule:Queue2':
      ensure                  => 'present',
      defaulttargeting        => '0',
      distributed             => '1',
      expirationloggingpolicy => '%header%%properties%',
      expirationpolicy        => 'Log',
      jndiname                => 'jms/Queue2',
      redeliverydelay         => '2000',
      redeliverylimit         => '3',
      subdeployment           => 'jmsServers',
      timetodeliver           => '-1',
      timetolive              => '300000',
    }

in hiera

    jms_queue_instances:
       'jmsClusterModule:ErrorQueue':
         ensure:                   'present'
         distributed:              '1'
         expirationpolicy:         'Discard'
         jndiname:                 'jms/ErrorQueue'
         redeliverydelay:          '-1'
         redeliverylimit:          '-1'
         subdeployment:            'jmsServers'
         defaulttargeting:         '0'
         timetodeliver:            '-1'
         timetolive:               '-1'
       'jmsClusterModule:Queue1':
         ensure:                   'present'
         distributed:              '1'
         errordestination:         'ErrorQueue'
         expirationpolicy:         'Redirect'
         jndiname:                 'jms/Queue1'
         redeliverydelay:          '2000'
         redeliverylimit:          '3'
         subdeployment:            'jmsServers'
         defaulttargeting:         '0'
         timetodeliver:            '-1'
         timetolive:               '300000'
       'jmsClusterModule:Queue2':
         ensure:                   'present'
         distributed:              '1'
         expirationloggingpolicy:  '%header%%properties%'
         expirationpolicy:         'Log'
         jndiname:                 'jms/Queue2'
         redeliverydelay:          '2000'
         redeliverylimit:          '3'
         subdeployment:            'jmsServers'
         defaulttargeting:         '0'
         timetodeliver:            '-1'
         timetolive:               '300000'


###wls_jms_topic

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name  

or use puppet resource wls_jms_topic

    wls_jms_topic { 'jmsClusterModule:Topic1':
      ensure           => 'present',
      defaulttargeting => '0',
      distributed      => '1',
      expirationpolicy => 'Discard',
      jndiname         => 'jms/Topic1',
      redeliverydelay  => '2000',
      redeliverylimit  => '2',
      subdeployment    => 'jmsServers',
      timetodeliver    => '-1',
      timetolive       => '300000',
    }

in hiera

    jms_topic_instances:
       'jmsClusterModule:Topic1':
         ensure:            'present'
         defaulttargeting:  '0'
         distributed:       '1'
         expirationpolicy:  'Discard'
         jndiname:          'jms/Topic1'
         redeliverydelay:   '2000'
         redeliverylimit:   '2'
         subdeployment:     'jmsServers'
         timetodeliver:     '-1'
         timetolive:        '300000'



###wls_jms_quota

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name  

or use puppet resource wls_jms_quota

    wls_jms_quota { 'jmsClusterModule:QuotaBig':
      ensure          => 'present',
      bytesmaximum    => '9223372036854775807',
      messagesmaximum => '9223372036854775807',
      policy          => 'FIFO',
      shared          => '1',
    }
    wls_jms_quota { 'jmsClusterModule:QuotaLow':
      ensure          => 'present',
      bytesmaximum    => '20000000000',
      messagesmaximum => '9223372036854775807',
      policy          => 'FIFO',
      shared          => '0',
    }
    

in hiera

    jms_quota_instances:
       'jmsClusterModule:QuotaBig':
          ensure:           'present'
          bytesmaximum:     '9223372036854775807'
          messagesmaximum:  '9223372036854775807'
          policy:           'FIFO'
          shared:           '1'
       'jmsClusterModule:QuotaLow':
          ensure:           'present'
          bytesmaximum:     '20000000000'
          messagesmaximum:  '9223372036854775807'
          policy:           'FIFO'
          shared:           '0'


###wls_jms_subdeployment

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name  

or use puppet resource wls_jms_subdeployment

    wls_jms_subdeployment { 'jmsClusterModule:jmsServers':
      ensure     => 'present',
      target     => ['jmsServer1','jmsServer2'],
      targettype => ['JMSServer','JMSServer'],
    }
    wls_jms_subdeployment { 'jmsClusterModule:wlsServers':
      ensure     => 'present',
      target     => ['WebCluster'],
      targettype => ['Cluster'],
    }

in hiera

    jms_subdeployment_instances:
       'jmsClusterModule:jmsServers':
          ensure:     'present'
          target:     
           - 'jmsServer1'
           - 'jmsServer2'
          targettype: 
          - 'JMSServer'
          - 'JMSServer'
       'jmsClusterModule:wlsServers':
          ensure:     'present'
          target:     
           - 'WebCluster'
          targettype: 
           - 'Cluster'
    

###wls_saf_remote_context

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name  

or use puppet resource wls_saf_remote_context

    wls_saf_remote_context { 'jmsClusterModule:RemoteSAFContext-0':
      ensure        => 'present',
      connect_url   => 't3://10.10.10.10:7001',
      weblogic_user => 'weblogic',
      weblogic_password => 'weblogic1',
    }
    wls_saf_remote_context { 'jmsClusterModule:RemoteSAFContext-1':
      ensure      => 'present',
      connect_url => 't3://10.10.10.10:7001',
    }

in hiera

    saf_remote_context_instances:
      'jmsClusterModule:RemoteSAFContext-0':
         ensure:            'present'
         connect_url:       't3://10.10.10.10:7001'
         weblogic_user:     'weblogic'
         weblogic_password: 'weblogic1'
      'jmsClusterModule:RemoteSAFContext-1':
         ensure:            'present'
         connect_url:       't3://10.10.10.10:7001'



###wls_saf_error_handler

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name  

or use puppet resource wls_saf_error_handler

    wls_saf_error_handler { 'jmsClusterModule:ErrorHandling-0':
      ensure => 'present',
      policy => 'Discard',
    }
    wls_saf_error_handler { 'jmsClusterModule:ErrorHandling-1':
      ensure    => 'present',
      logformat => '%header%%properties%',
      policy    => 'Log',
    }

in hiera

    saf_error_handler_instances:
      'jmsClusterModule:ErrorHandling-0':
         ensure:           'present'
         policy:           'Discard'
      'jmsClusterModule:ErrorHandling-1':
         ensure:           'present'
         policy:           'Log'
         logformat:        '%header%%properties%'

###wls_saf_imported_destination

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name  

or use puppet resource wls_saf_imported_destination

    wls_saf_imported_destination { 'jmsClusterModule:SAFImportedDestinations-0':
      ensure               => 'present',
      defaulttargeting     => '1',
      errorhandling        => 'ErrorHandling-0',
      jndiprefix           => 'saf_',
      remotecontext        => 'RemoteSAFContext-0',
      timetolivedefault    => '1000000000',
      usetimetolivedefault => '1',
    }
    wls_saf_imported_destination { 'jmsClusterModule:SAFImportedDestinations-1':
      ensure               => 'present',
      defaulttargeting     => '0',
      jndiprefix           => 'saf2_',
      remotecontext        => 'RemoteSAFContext-1',
      subdeployment        => 'safServers',
      usetimetolivedefault => '0',
    }

in hiera

    'jmsClusterModule:SAFImportedDestinations-1':
      ensure:               'present'
      defaulttargeting:     '1'
      jndiprefix:           'saf2_'
      remotecontext:        'RemoteSAFContext-1'
    'jmsClusterModule:SAFImportedDestinations-0':
      ensure:               'present'
      defaulttargeting:     '0'
      subdeployment:        'safServers'
      errorhandling:        'ErrorHandling-1'
      jndiprefix:           'saf_'
      remotecontext:        'RemoteSAFContext-0'
      timetolivedefault:    '100000000'
      usetimetolivedefault: '1'

###wls_saf_imported_destination_object

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name and imported_destination 

or use puppet resource wls_saf_imported_destination_object

    wls_saf_imported_destination_object { 'jmsClusterModule:SAFImportedDestinations-0:SAFDemoQueue':
      ensure               => 'present',
      nonpersistentqos     => 'Exactly-Once',
      object_type          => 'queue',
      remotejndiname       => 'jms/DemoQueue',
      unitoforderrouting   => 'Hash',
      usetimetolivedefault => '0',
    }
    wls_saf_imported_destination_object { 'jmsClusterModule:SAFImportedDestinations-0:SAFDemoTopic':
      ensure               => 'present',
      nonpersistentqos     => 'Exactly-Once',
      object_type          => 'topic',
      remotejndiname       => 'jms/DemoTopic',
      timetolivedefault    => '100000000',
      unitoforderrouting   => 'Hash',
      usetimetolivedefault => '1',
    }

in hiera

    saf_imported_destination_object_instances:
      'jmsClusterModule:SAFImportedDestinations-0:SAFDemoQueue':
          ensure:                'present'
          object_type:           'queue'
          remotejndiname:        'jms/DemoQueue'
          unitoforderrouting:    'Hash'
          nonpersistentqos:      'Exactly-Once'
      'jmsClusterModule:SAFImportedDestinations-0:SAFDemoTopic':
          ensure:                'present'
          object_type:           'topic'
          remotejndiname:        'jms/DemoTopic'
          timetolivedefault:     '100000000'
          unitoforderrouting:    'Hash'
          usetimetolivedefault:  '1'
          nonpersistentqos:      'Exactly-Once'

###wls_foreign_server

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name 

or use puppet resource wls_foreign_server

    wls_foreign_server { 'jmsClusterModule:AQForeignServer':
      ensure                => 'present',
      defaulttargeting      => '1',
      extraproperties       => 'datasource',
      extrapropertiesvalues => ['jdbc/hrDS'],
      initialcontextfactory => ['oracle.jms.AQjmsInitialContextFactory'],
    }
    wls_foreign_server { 'jmsClusterModule:Jboss':
      ensure                => 'present',
      connectionurl         => 'remote://10.10.10.10:4447',
      defaulttargeting      => '0',
      extraproperties       => ['java.naming.security.principal'],
      extrapropertiesvalues => ['jmsuser'],
      initialcontextfactory => 'org.jboss.naming.remote.client.InitialContextFactory',
      subdeployment         => 'wlsServers',
    }

in hiera

    'jmsClusterModule:AQForeignServer':
        ensure:                'present'
        defaulttargeting:      '1'
        extraproperties:       
          - 'datasource'
        extrapropertiesvalues: 
          - 'jdbc/hrDS'
        initialcontextfactory: 'oracle.jms.AQjmsInitialContextFactory'
    'jmsClusterModule:Jboss':
        ensure:                'present'
        connectionurl:         'remote://10.10.10.10:4447'
        defaulttargeting:      '0'
        extraproperties:       
          - 'java.naming.security.principal'
        extrapropertiesvalues: 
          - 'jmsuser'
        initialcontextfactory: 'org.jboss.naming.remote.client.InitialContextFactory'
        subdeployment:         'wlsServers'
        password:              'test'


###wls_foreign_server_object

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name and foreign server 

or use puppet resource wls_foreign_server_object

    wls_foreign_server_object { 'jmsClusterModule:Jboss:CF':
      ensure         => 'present',
      localjndiname  => 'jms/jboss/CF',
      object_type    => 'connectionfactory',
      remotejndiname => 'jms/Remote/CF',
    }
    wls_foreign_server_object { 'jmsClusterModule:Jboss:JBossQ':
      ensure         => 'present',
      localjndiname  => 'jms/jboss/Queue',
      object_type    => 'destination',
      remotejndiname => 'jms/Remote/Queue',
    }


in hiera

    'jmsClusterModule:Jboss:CF':
        ensure:         'present'
        localjndiname:  'jms/jboss/CF'
        object_type:    'connectionfactory'
        remotejndiname: 'jms/Remote/CF'
    'jmsClusterModule:Jboss:JBossQ':
        ensure:         'present'
        localjndiname:  'jms/jboss/Queue'
        object_type:    'destination'
        remotejndiname: 'jms/Remote/Queue'
    'jmsClusterModule:AQForeignServer:XAQueueCF':
        ensure:         'present'
        localjndiname:  'jms/XAQueueCF'
        object_type:    'connectionfactory'
        remotejndiname: 'XAQueueConnectionFactory'
    'jmsClusterModule:AQForeignServer:TestQueue':
        ensure:         'present'
        localjndiname:  'jms/aq/TestQueue'
        object_type:    'destination'
        remotejndiname: 'Queues/TestQueue'


