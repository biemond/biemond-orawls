# Oracle WebLogic / Fusion Middleware puppet module V2
[![Build Status](https://travis-ci.org/biemond/biemond-orawls.svg?branch=master)](https://travis-ci.org/biemond/biemond-orawls) ![Puppet Forge Version](https://img.shields.io/puppetforge/v/biemond/orawls.svg) ![Puppet Forge Score](https://img.shields.io/puppetforge/f/biemond/orawls.svg) ![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/biemond/orawls.svg) [![Code Climate](https://codeclimate.com/github/biemond/biemond-orawls/badges/gpa.svg)](https://codeclimate.com/github/biemond/biemond-orawls) [![Coverage Status](https://coveralls.io/repos/biemond/biemond-orawls/badge.svg?branch=master&service=github)](https://coveralls.io/github/biemond/biemond-orawls?branch=master)

Install, configures and manages WebLogic version 10.3 - 12.2.1.1

This module should work for all Linux & Solaris versions like RedHat, CentOS, Ubuntu, Debian, Suse SLES, OracleLinux, Solaris 10,11 sparc / x86

Only for Puppet >= 4.3 and uses the latest puppet 4 features like
- Strong data typing
- Internal hiera module data
- uses Facts array
- epp templating instead of erb

For Puppet 3, 4 you have to use the latest 1.x version of this orawls module

source code is located at [puppet4 branch](https://github.com/biemond/biemond-orawls/tree/puppet4)


## Author

Edwin Biemond email biemond at gmail dot com

[biemond.blogspot.com](http://biemond.blogspot.com)

[Github homepage](https://github.com/biemond/biemond-orawls)

## Contributors

Special thanks to all the contributors

More: https://github.com/biemond/biemond-orawls/graphs/contributors

## Support

If you need support, checkout the [wls_install](https://www.enterprisemodules.com/shop/products/puppet-wls_install-module) and [wls_config](https://www.enterprisemodules.com/shop/products/puppet-wls_config-module) modules from [Enterprise Modules](https://www.enterprisemodules.com/)
[![Enterprise Modules](https://raw.githubusercontent.com/enterprisemodules/public_images/master/banner1.jpg)](https://www.enterprisemodules.com)

## Dependencies

- hajee/easy_type >=0.10.0
- adrien/filemapper >= 1.1.1
- reidmv/yamlfile >=0.2.0
- fiddyspence/sleep => 1.1.2
- puppetlabs/stdlib => 4.9.0

## Complete vagrant examples

- Docker with WebLogic 12.1.3 Cluster [docker-weblogic-puppet](https://github.com/biemond/docker-weblogic-puppet)
- WebLogic 12.2.1.1 MT multi tenancy / Puppet 4 Reference implementation, the vagrant test case for full working WebLogic 12.2.1 cluster example [biemond-orawls-vagrant-12.2.1-puppet4](https://github.com/biemond/biemond-orawls-vagrant-12.2.1-puppet4)
- WebLogic 12.2.1.1 infra (JRF + JRF restricted), the vagrant test case for full working WebLogic 12.2.1 infra cluster example with WebTier (Oracle HTTP Server) [biemond-orawls-vagrant-12.2.1-infra-puppet4](https://github.com/biemond/biemond-orawls-vagrant-12.2.1-infra-puppet4)
- WebLogic 12.2.1.1 infra (JRF + JRF restricted), the vagrant test case for full working WebLogic 12.2.1 infra SOA Suite/BAM/OSB cluster example [biemond-orawls-vagrant-12.2.1-infra-soa](https://github.com/biemond/biemond-orawls-vagrant-12.2.1-infra-soa)
- WebLogic OHS webtier standalone, the vagrant test case for full working Webtier 12.1.2 and 12.2.1 [biemond-orawls-vagrant-ohs-puppet4](https://github.com/biemond/biemond-orawls-vagrant-ohs-puppet4)
- WebLogic 12.1.3 / Puppet 4.2.1 Reference implementation, the vagrant test case for full working WebLogic 12.1.3 cluster example [biemond-orawls-vagrant-12.1.3](https://github.com/biemond/biemond-orawls-vagrant-12.1.3)
- WebLogic 12.1.3 infra (JRF), the vagrant test case for full working WebLogic 12.1.3 infra cluster example with WebTier (Oracle HTTP Server) [biemond-orawls-vagrant-12.1.3-infra](https://github.com/biemond/biemond-orawls-vagrant-12.1.3-infra)
- WebLogic 12.1.3 infra with OSB, the vagrant test case for full working WebLogic 12.1.3 infra OSB cluster example [biemond-orawls-vagrant-12.1.3-infra-osb](https://github.com/biemond/biemond-orawls-vagrant-12.1.3-infra-osb)
- WebLogic 12.1.3 infra with OSB & SOA,ESS,BAM, the vagrant test case for full working WebLogic 12.1.3 infra OSB SOA Cluster example [biemond-orawls-vagrant-12.1.3-infra-soa](https://github.com/biemond/biemond-orawls-vagrant-12.1.3-infra-soa)
- WebLogic 12.1.2 Reference implementation, the vagrant test case for full working WebLogic 12.1.2 cluster example [biemond-orawls-vagrant-12.1.2](https://github.com/biemond/biemond-orawls-vagrant-12.1.2)
- WebLogic 12.1.2 infra (JRF) with WebTier, the vagrant test case for full working WebLogic 12.1.2 infra cluster example with WebTier (Oracle HTTP Server) [biemond-orawls-vagrant-12.1.2-infra](https://github.com/biemond/biemond-orawls-vagrant-12.1.2-infra)
- Reference Solaris implementation, the vagrant test case for full working WebLogic 12.1.3 cluster example [biemond-orawls-vagrant-solaris](https://github.com/biemond/biemond-orawls-vagrant-solaris)
- Reference OIM / OAM with WebTier, Webgate & Oracle Unified Directory, the vagrant test case for Oracle Identity Manager & Oracle Access Manager 11.1.2.3 example [biemond-orawls-vagrant-oim_oam](https://github.com/biemond/biemond-orawls-vagrant-oim_oam)
- Reference OIM / OAM Cluster, the vagrant test case for Oracle Identity Manager & Oracle Access Manager 11.1.2.3 cluster example [biemond-orawls-vagrant-oim_oam_cluster](https://github.com/biemond/biemond-orawls-vagrant-oim_oam_cluster)
- WebLogic 11g Reference implementation, the vagrant test case for full working WebLogic 10.3.6 cluster example [biemond-orawls-vagrant](https://github.com/biemond/biemond-orawls-vagrant)
- Reference Oracle SOA Suite, the vagrant test case for full working WebLogic 10.3.6 SOA Suite + OSB cluster example [biemond-orawls-vagrant-solaris-soa](https://github.com/biemond/biemond-orawls-vagrant-solaris-soa)
- Example of Opensource Puppet 3.4.3 Puppet master configuration in a vagrant box [vagrant-puppetmaster](https://github.com/biemond/vagrant-puppetmaster)
- Oracle Forms, Reports 11.1.1.7 & 11.1.2 Reference implementation, the vagrant test case [biemond-orawls-vagrant-11g-forms](https://github.com/biemond/biemond-orawls-vagrant-11g-forms)


## Orawls WebLogic Features

- [Installs WebLogic](#weblogic), version 10g,11g,12c( 12.1.1, 12.1.2, 12.1.3, 12.2.1, 12.2.1.1 + its FMW infrastructure editions )
- [Apply a BSU patch](#bsu) on a Middleware home ( < 12.1.2 )
- [Apply a OPatch](#opatch) on a Middleware home ( >= 12.1.2 ) or a Oracle product home
- [Create a WebLogic domain](#domain)
- [Pack a WebLogic domain](#packdomain)
- [Copy a WebLogic domain](#copydomain) to a other node with SSH, unpack and enroll to a nodemanager
- [JSSE](#jsse) Java Secure Socket Extension support
- [Override the default file location, applicable for running as non-root user](#default_override)
- [Custom Identity and Trust Store support](#identity)
- [Linux low on entropy or urandom fix](#urandom)
- [Startup a nodemanager](#nodemanager)
- [start or stop AdminServer, Managed or a Cluster](#control)
- [StoreUserConfig](#storeuserconfig) for storing WebLogic Credentials and using in WLST
- [Dynamic targetting](#Dynamictargetting) by using the notes field in WebLogic for resource targetting
- 12.2.1 Multi Tenancy features

### Fusion Middleware Features 11g & 12c

- installs [FMW](#fmw) software(add-on) to a middleware home, like OSB,SOA Suite, Oracle Identity & Access Management, Oracle Unified Directory, WebCenter Portal + Content
- [WebTier](#webtier) Oracle HTTP server Standalone and Collocated
- [Configure Oracle HTTP Server](#configure-oracle-http-server)
- [OSB, SOA Suite](#fmwcluster) with BPM and BAM Cluster configuration support ( convert single osb/soa/bam servers to clusters and migrate 11g OPSS to the database )
- [ADF/JRF support](#fmwclusterjrf), Assign JRF libraries to a Server or Cluster target
- [OIM IDM](#oimconfig) / OAM 11.1.2.3 configurations with Oracle OHS OAM WebGate, Also it has Cluster support for OIM OAM
- [OUD](#instance) OUD Oracle Unified Directory install, WebLogic domain, instances creation & [OUD control](#oud_control)
- [Forms/Reports](#forms) Oracle Forms & Reports 11.1.1.7, 11.1.2 or 12.2.1
- [WC, WCC, WCS](#Webcenter) Webcenter portal, content, sites 11g or 12.2.1
- [Change FMW log](#fmwlogdir) location of a managed server
- [Resource Adapter](#resourceadapter) plan and entries for AQ, DB, MQ, FTP, File and JMS

## Wls types and providers

This will use WLST to retrieve the current state and to the changes. With WebLogic 12.2.1 we can also use the rest management api's, it's already working in this module but we will slowly support this for all wls types

- [wls_setting](#wls_setting), set the default wls parameters for the other types and also used by puppet resource
- [wls_adminserver](#wls_adminserver) control the adminserver or subscribe to changes
- [wls_managedserver](#wls_managedserver) control the managed server,cluster or subscribe to changes
- [wls_ohsserver](#wls_ohsserver) control the ohs standalone server or subscribe to changes
- [wls_domain](#wls_domain)
- [wls_deployment](#wls_deployment)
- [wls_domain](#wls_domain)
- [wls_group](#wls_group)
- [wls_role](#wls_role)
- [wls_user](#wls_user)
- [wls_authentication_provider](#wls_authentication_provider)
- [wls_identity_asserter](#wls_identity_asserter)
- [wls_machine](#wls_machine)
- [wls_server](#wls_server)
- [wls_server_channel](#wls_server_channel)
- [wls_server_tlog](#wls_server_tlog)
- [wls_cluster](#wls_cluster)
- [wls_migratable_target](#wls_migratable_target)
- [wls_singleton_service](#wls_singleton_service)
- [wls_virtual_host](#wls_virtual_host)
- [wls_workmanager_constraint](#wls_workmanager_constraint)
- [wls_workmanager](#wls_workmanager)
- [wls_datasource](#wls_datasource)
- [wls_multi_datasource](#wls_multi_datasource)
- [wls_foreign_jndi_provider ](#wls_foreign_jndi_provider )
- [wls_foreign_jndi_provider _link](#wls_foreign_jndi_provider _link)
- [wls_file_persistence_store](#wls_file_persistence_store)
- [wls_jdbc_persistence_store](#wls_jdbc_persistence_store)
- [wls_jmsserver](#wls_jmsserver)
- [wls_safagent](#wls_safagent)
- [wls_jms_module](#wls_jms_module)
- [wls_jms_quota](#wls_jms_quota)
- [wls_jms_sort_destination_key](#wls_jms_sort_destination_key)
- [wls_jms_subdeployment](#wls_jms_subdeployment)
- [wls_jms_queue](#wls_jms_queue)
- [wls_jms_topic](#wls_jms_topic)
- [wls_jms_security_policy](#wls_jms_security_policy)
- [wls_jms_connection_factory](#wls_jms_connection_factory)
- [wls_jms_template](#wls_jms_template)
- [wls_jms_bridge_destination](#wls_jms_bridge_destination)
- [wls_messaging_bridge](#wls_messaging_bridge)
- [wls_saf_remote_context](#wls_saf_remote_context)
- [wls_saf_error_handler](#wls_saf_error_handler)
- [wls_saf_imported_destination](#wls_saf_imported_destination)
- [wls_saf_imported_destination_object](#wls_saf_imported_destination_object)
- [wls_foreign_server](#wls_foreign_server)
- [wls_foreign_server_object](#wls_foreign_server_object)
- [wls_mail_session](#wls_mail_session)

12.1.3 Coherence & Dynamic clusters
- [wls_coherence_cluster](#wls_coherence_cluster)
- [wls_coherence_server](#wls_coherence_server)
- [wls_server_template](#wls_server_template)
- [wls_dynamic_cluster](#wls_dynamic_cluster)

12.2.1.1 Multitenancy MT
- [wls_virtual_target](#wls_virtual_target)
- [wls_resource_group](#wls_resource_group)
- [wls_resource_group_template](#wls_resource_group_template)
- [wls_resource_group_template_deployment](#wls_resource_group_template_deployment)
- [wls_domain_partition](#wls_domain_partition)
- [wls_domain_partition_control](#wls_domain_partition_control)
- [wls_domain_partition_resource_group](#wls_domain_partition_resource_group)
- [wls_domain_partition_resource_group_deployment](#wls_domain_partition_resource_group_deployment)

## Domain creation options (Dev or Prod mode)

all templates creates a WebLogic domain, logs the domain creation output

For all WebLogic or FMW versions
- domain 'standard'       -> a default WebLogic
- domain 'adf'            -> JRF + EM + Coherence (12.1.2, 12.1.3, 12.2.1) + OWSM (12.1.2, 12.1.3, 12.2.1) + JAX-WS Advanced + Soap over JMS (12.1.2, 12.1.3, 12.2.1)
- domain 'osb'            -> OSB + JRF + EM + OWSM + ESS ( optional with 12.1.3 )
- domain 'osb_soa'        -> OSB + SOA Suite + BAM + JRF + EM + OWSM + ESS ( optional with 12.1.3 )
- domain 'osb_soa_bpm'    -> OSB + SOA Suite + BAM + BPM + JRF + EM + OWSM + ESS ( optional with 12.1.3 )
- domain 'soa'            -> SOA Suite + BAM + JRF + EM + OWSM + ESS ( optional with 12.1.3 )
- domain 'soa_bpm'        -> SOA Suite + BAM + BPM + JRF + EM + OWSM + ESS ( optional with 12.1.3 )
- domain 'bam'            -> BAM ( only with soa suite installation)
- domain 'ohs_standalone' -> Standalone webtier (HTTP Server) 12.1.2, 12.1.3 and 12.1.4

11g
- domain 'wc_wcc_bpm'     -> WC (webcenter) + WCC ( Content ) + BPM + JRF + EM + OWSM
- domain 'wc'             -> WC (webcenter) + JRF + EM + OWSM

11gR2
- domain 'oim'            -> IDM, OIM (Oracle Identity Manager) + OAM ( Oracle Access Manager)
- domain 'oud'            -> OUD (Oracle Unified Directory)

12.2.1.1
- domain 'adf_restricted' -> only for 12.2.1 (no RCU/DB) JRF + EM + Coherence + JAX-WS Advanced + Soap over JMS


## Puppet master with orawls module key points
it should work on every PE or opensource puppet master, customers and I successfully tested orawls on PE 3.0, 3.1, 3.2, 3.3. See also the puppet master vagrant box

For Running orawls module without root/elevated privileges, please use v3.7.0 or higher

But when it fails you can do the following actions.
- Check the time difference/timezone between all the puppet master and agent machines.
- Update orawls and its dependencies on the puppet master.
- After adding or refreshing the easy_type or orawls modules you need to restart all the PE services on the puppet master (this will flush the PE cache) and always do a puppet agent run on the Puppet master
- To solve this error "no such file to load -- easy_type" you need just to do a puppet run on the puppet master when it is still failing you can move the easy_type module to its primary module location ( /etc/puppetlabs/puppet/module )
- Move orawls and easy_type to the primary module location [pup-1515](https://tickets.puppetlabs.com/browse/PUP-1515) when the Puppet master loads a Type, it searches the environment that the agent requested. When it loads providers for that type, it searches the default environment instead of the one the agent requested.

## Orawls WebLogic Facter

Contains WebLogic Facter which displays the following
- Middleware homes
- Oracle Software
- BSU & OPatch patches
- Domain configuration ( everything of a WebLogic Domain like deployments, datasource, JMS, SAF)


## Override the default Oracle operating system user

default this orawls module uses oracle as weblogic install user
you can override this by setting the following fact 'override_weblogic_user', like override_weblogic_user=wls or set FACTER_override_weblogic_user=wls

## <a name="default_override">Override the default file location where orawls saves domain & other settings (Applicable for running as non-root user)

default this orawls module saves the domain & connection related setting in /etc in yaml format
you can override this by setting the following 2 facts:

for domain information: override_wls_domains_file=[custom_path]/wls_domains.yaml
or set FACTER_override_wls_domains_file=[custom_path]/wls_domains.yaml

for settings infortmation: override_wls_setting_file=[custom_path]/wls_setting.yaml
or set FACTER_override_wls_setting_file=[custom_path]/wls_setting.yaml

for ora inst location: override_orainst_dir=[custom_path]
or set FACTER_override_orainst_dir=[custom_path]

Set $puppet_os_user on some of the manifests or set this hiera variable puppet_os_user


## Override the default WebLogic domain folder

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

## <a name="jsse">Java Secure Socket Extension support</a>

Requires the JDK 7 or 8 JCE extension

    jdk7::install7{ 'jdk-8u72-linux-x64':
        version                     => "8u72" ,
        full_version                => "jdk1.8.0_72",
        alternatives_priority       => 18001,
        x64                         => true,
        download_dir                => "/var/tmp/install",
        urandom_java_fix            => true,
        rsa_key_size_fix            => true,
        cryptography_extension_file => "jce_policy-8.zip",
        source_path                 => "/software",
    }


    jdk7::install7{ 'jdk1.7.0_51':
        version                     => "7u51" ,
        full_version                => "jdk1.7.0_51",
        alternatives_priority       => 18000,
        x64                         => true,
        download_dir                => "/var/tmp/install",
        urandom_java_fix            => true,
        rsa_key_size_fix            => true,                          <!--
        cryptography_extension_file => "UnlimitedJCEPolicyJDK7.zip",  <!---
        source_path                 => "/software",
    }


To enable this in orawls you can set the jsse_enabled on the following manifests
- nodemanager.pp
- domain.pp
- control.pp


## <a name="identity">Enterprise security with Custom Identity and Trust store</a>

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

    wls_setting_instances:
      'default':
        user:                      oracle
        weblogic_home_dir:         '/opt/oracle/middleware11g/wlserver_10.3'
        connect_url:               't3s://10.10.10.10:7002'
        weblogic_user:             'weblogic'
        weblogic_password:         'Welcome01'
        custom_trust:              *wls_custom_trust
        trust_keystore_file:       *wls_trust_keystore_file
        trust_keystore_passphrase: *wls_trust_keystore_passphrase

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


## <a name="urandom">Linux low on entropy or urandom fix</a>

can cause certain operations to be very slow. Encryption operations need entropy to ensure randomness. Entropy is generated by the OS when you use the keyboard, the mouse or the disk.

If an encryption operation is missing entropy it will wait until enough is generated.

three options
-  use rngd service (include __orawls::urandomfix__ class)
-  set java.security in JDK ( jre/lib/security in my jdk7 module )
-  set -Djava.security.egd=file:/dev/./urandom param

## Oracle binaries files and alternate download location

Some manifests like orawls:weblogic bsu opatch fmw supports an alternative mountpoint for the big oracle setup/install files.
When not provided it uses the files folder located in the orawls puppet module
else you can use $puppet_download_mnt_point =>
- "/mnt"
- "/vagrant"
- "puppet:///modules/orawls/" (default)
- "puppet:///middleware/"

when the files are also accesiable locally then you can also set $remote_file => false this will not move the files to the download folder, just extract or install

## WebLogic requirements

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


## Necessary Hiera setup for global vars and Facter

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
	wls_version:              &wls_version              12212

	# global OS vars
	wls_source:               &wls_source               "/software"
	wls_jdk_home_dir:         &wls_jdk_home_dir         "/usr/java/latest"
	wls_log_dir:              &wls_log_dir              "/var/log/weblogic"

	wls_domains_dir:          &wls_domains_dir          '/opt/oracle/wlsdomains/domains'
	wls_apps_dir:             &wls_apps_dir             '/opt/oracle/wlsdomains/applications'

	wls_jsse_enabled:         true


## WebLogic Module Usage

### weblogic
__orawls::weblogic__ installs WebLogic 10.3.[0-6], 12.1.1, 12.1.2, 12.1.3, 12.2.1, 12.2.1.2


	include orawls::weblogic

	orawls::weblogic::version:                   *wls_version  # 1036|1211|1212|1213|1221|12212
	orawls::weblogic::filename:                  'fmw_12.2.1.2.0_wls.jar'
	orawls::weblogic::log_output:                true
	orawls::weblogic::jdk_home_dir:              *wls_jdk_home_dir
	orawls::weblogic::oracle_base_home_dir:      *wls_oracle_base_home_dir
	orawls::weblogic::puppet_download_mnt_point: *wls_source
	orawls::weblogic::remote_file:               false
	orawls::weblogic::wls_domains_dir:           *wls_domains_dir
	orawls::weblogic::wls_apps_dir:              *wls_apps_dir
	orawls::weblogic::middleware_home_dir:       *wls_middleware_home_dir

12.1.3 infra

	orawls::weblogic::version:                   *wls_version
	orawls::weblogic::filename:                  'fmw_12.2.1.2.0_infrastructure.jar'
	orawls::weblogic::fmw_infra:                 true
	orawls::weblogic::log_output:                true
	orawls::weblogic::jdk_home_dir:              *wls_jdk_home_dir
	orawls::weblogic::oracle_base_home_dir:      *wls_oracle_base_home_dir
	orawls::weblogic::puppet_download_mnt_point: *wls_source
	orawls::weblogic::remote_file:               false
	orawls::weblogic::weblogic_home_dir:         *wls_weblogic_home_dir
	orawls::weblogic::middleware_home_dir:       *wls_middleware_home_dir


or with a bin file located on a share

	orawls::weblogic::version:                   1036
	orawls::weblogic::filename:                  "oepe-wls-indigo-installer-11.1.1.8.0.201110211138-10.3.6-linux32.bin"
	orawls::weblogic::fmw_infra:                 true
	orawls::weblogic::log_output:                true
	orawls::weblogic::jdk_home_dir:              *wls_jdk_home_dir
	orawls::weblogic::oracle_base_home_dir:      *wls_oracle_base_home_dir
	orawls::weblogic::puppet_download_mnt_point: "/misc/tact/products/oracle/11g/fmw/wls/11.1.1.8"
	orawls::weblogic::remote_file:               true
	orawls::weblogic::wls_domains_dir:           *wls_domains_dir
	orawls::weblogic::wls_apps_dir:              *wls_apps_dir
	orawls::weblogic::middleware_home_dir:       *wls_middleware_home_dir
    orawls::weblogic::weblogic_home_dir:         "/opt/weblogic/Middleware/wlserver_10.3"


### weblogic_type
__orawls::weblogic_type__ same as weblogic manifest/class but now as define which supports multiple middleware home on same VM

    orawls::weblogic{'1221':
      version                   => 12211,                       # 1036|1211|1212|1213|1221|12212
      filename                  => 'fmw_12.2.1.0.0_wls.jar',   # wls1036_generic.jar|wls1211_generic.jar|wls_121200.jar
      jdk_home_dir              => '/usr/java/jdk1.8.0_45',
      oracle_base_home_dir      => "/opt/oracle",
      middleware_home_dir       => "/opt/oracle/middleware12c",
      weblogic_home_dir         => "/opt/oracle/middleware12c/wlserver",
      os_user                   => "oracle",
      os_group                  => "dba",
      download_dir              => "/data/install",
      puppet_download_mnt_point => "/vagrant",                 # puppet:///modules/orawls/ | /mnt |
      log_output                => true,
    }


### opatch
__orawls::opatch__ apply an OPatch on a Middleware home or a Oracle product home

Most general parameters are derived from weblogic.pp, you don't need to specify them again


    orawls::opatch {'16175470':
      ensure                  => "present",
      oracle_product_home_dir => "/opt/oracle/middleware12c",
      patch_id                => 16175470,
      patch_file              => "p16175470_121200_Generic.zip",
    }

Same configuration but then with Hiera

    $default_params = {}
    $opatch_instances = hiera('opatch_instances', {})
    create_resources('orawls::opatch',$opatch_instances, $default_params)

common.yaml

    ---
	opatch_instances:
	  '24910964':
	    ensure:                   'present'
	    oracle_product_home_dir:  *wls_middleware_home_dir
	    patch_id:                 24910964
	    patch_file:               "p24910964_122120_Generic.zip"


### bsu
__orawls::bsu__ apply or remove a WebLogic BSU Patch ( ensure = present or absent )


Most general parameters are derived from weblogic.pp, you don't need to specify them again


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


### fmw
__orawls::fmw__ installs FMW software (add-on) to a middleware home like OSB,SOA Suite, WebTier (HTTP Server), Oracle Identity Management, Web Center, Content + Sites

    Enum['adf','soa','soaqs','osb','wcc','wc','wcs','oim','oam','web','webgate','oud','mft','b2b','forms'] fmw_product

Most general parameters are derived from weblogic.pp, you don't need to specify them again

	logoutput:                &logoutput                true

	wls_oracle_base_home_dir: &wls_oracle_base_home_dir "/opt/oracle"
	wls_weblogic_user:        &wls_weblogic_user        "weblogic"
	wls_weblogic_home_dir:    &wls_weblogic_home_dir    "/opt/oracle/middleware12c/wlserver"
	wls_middleware_home_dir:  &wls_middleware_home_dir  "/opt/oracle/middleware12c"
	wls_version:              &wls_version              12212

	# global OS vars
	wls_os_user:              &wls_os_user              "oracle"
	wls_os_group:             &wls_os_group             "dba"
	wls_download_dir:         &wls_download_dir         "/var/tmp/install"
	wls_source:               &wls_source               "/software"
	wls_jdk_home_dir:         &wls_jdk_home_dir         "/usr/java/latest"
	wls_log_dir:              &wls_log_dir              "/var/log/weblogic"

    $default_params = {}
    $fmw_installations = hiera('fmw_installations', {})
    create_resources('orawls::fmw',$fmw_installations, $default_params)

	# FMW installation on top of WebLogic 12.2.1
	fmw_installations:
	  'webtier1221':
	    fmw_product:               "web"
	    fmw_file1:                 "fmw_12.2.1.2.0_ohs_linux64_Disk1_1of1.zip"
	    oracle_base_home_dir:      *wls_oracle_base_home_dir
	  'soa1221':
	    fmw_product:               "soa"
	    fmw_file1:                 "fmw_12.2.1.2.0_soa_Disk1_1of1.zip"
	    oracle_base_home_dir:      *wls_oracle_base_home_dir
	    bpm:                       true
	  'osb1221':
	    fmw_product:               "osb"
	    fmw_file1:                 "fmw_12.2.1.2.0_osb_Disk1_1of1.zip"
	    oracle_base_home_dir:      *wls_oracle_base_home_dir
	  'forms1221':
	    fmw_product:               "forms"
	    fmw_file1:                 "fmw_12.2.1.2.0_fr_linux64_Disk1_1of1.zip"
	    oracle_base_home_dir:      *wls_oracle_base_home_dir
	  'wcc1221':
	    fmw_product:               "wcc"
	    fmw_file1:                 "fmw_12.2.1.2.0_wccontent_Disk1_1of1.zip"
	    oracle_base_home_dir:      *wls_oracle_base_home_dir
	  'wc1221':
	    fmw_product:               "wc"
	    fmw_file1:                 "fmw_12.2.1.2.0_wcportal_Disk1_1of1.zip"
	    oracle_base_home_dir:      *wls_oracle_base_home_dir
	  'wcs1221':
	    fmw_product:               "wcs"
	    fmw_file1:                 "fmw_12.2.1.2.0_wcsites_Disk1_1of1.zip"
	    wcs_mode:                  'sites' # Enum['sites','examples','satellite']
	    oracle_base_home_dir:      *wls_oracle_base_home_dir

    # OHS standalone
	fmw_installations:
	  'webtier1212':
	    fmw_product:               "web"
	    ohs_mode:                  "standalone"
	    fmw_file1:                 "fmw_12.2.1.2.0_ohs_linux64_Disk1_1of1.zip"
	    log_output:                true
	    remote_file:               false
	    version:                   *wls_version
	    weblogic_home_dir:         *wls_weblogic_home_dir
	    middleware_home_dir:       *wls_middleware_home_dir
	    jdk_home_dir:              *wls_jdk_home_dir
	    oracle_base_home_dir:      *wls_oracle_base_home_dir
	    os_user:                   *wls_os_user
	    os_group:                  *wls_os_group
	    download_dir:              *wls_download_dir
	    puppet_download_mnt_point: *wls_source




### domain
__orawls::domain__ creates WebLogic domain like a standard | OSB or SOA Suite | ADF | WebCenter | OIM or OAM or OUD


Most general parameters are derived from weblogic.pp, you don't need to specify them again

optional override the default server arguments in the domain.py template with java_arguments parameter


	wls_os_user:              &wls_os_user              "oracle"
	wls_weblogic_home_dir:    &wls_weblogic_home_dir    "/opt/oracle/middleware12c/wlserver"
	wls_middleware_home_dir:  &wls_middleware_home_dir  "/opt/oracle/middleware12c"

	wls_jsse_enabled:         &wls_jsse_enabled         true
	wls_log_dir:              &wls_log_dir              "/var/log/weblogic"

	# when you have just one domain on a server
	domain_name:                &domain_name                "Wls1221"
	domain_wls_password:        &domain_wls_password        "weblogic1"

	domain_adminserver_address: &domain_adminserver_address "%{hiera('adminserver_address')}"
	domain_node1_address:       &domain_node1_address       "%{hiera('node1_address')}"
	domain_node2_address:       &domain_node2_address       "%{hiera('node2_address')}"

	# used by nodemanager, control and domain creation
	wls_custom_trust:                  &wls_custom_trust              true
	wls_trust_keystore_file:           &wls_trust_keystore_file       '/vagrant/truststore.jks'
	wls_trust_keystore_passphrase:     &wls_trust_keystore_passphrase 'welcome'

    $default = {}
    $domain_instances = hiera('domain_instances', {})
    create_resources('orawls::domain',$domain_instances, $default)


vagrantcentos64.example.com.yaml

    ---
	domain_instances:
	  'Wls1221':
	    domain_template:                       "standard"
	    weblogic_home_dir:                     *wls_weblogic_home_dir
	    domain_name:                           *domain_name
	    development_mode:                      false
	    adminserver_address:                   *domain_adminserver_address
	    adminserver_ssl_port:                  7002
	    custom_trust:                          *wls_custom_trust
	    trust_keystore_file:                   *wls_trust_keystore_file
	    trust_keystore_passphrase:             *wls_trust_keystore_passphrase
	    custom_identity:                       true
	    custom_identity_keystore_filename:     '/vagrant/identity_admin.jks'
	    custom_identity_keystore_passphrase:   'welcome'
	    custom_identity_alias:                 'admin'
	    custom_identity_privatekey_passphrase: 'welcome'
	    weblogic_password:                     *domain_wls_password
	    jsse_enabled:                          *wls_jsse_enabled
	    log_dir:                               *wls_log_dir
	  'plain_Wls':
	    domain_template:                       "standard"
	    weblogic_home_dir:                     *wls_weblogic_home_dir
	    domain_name:                           "plain_Wls"
	    development_mode:                      false
	    adminserver_address:                   *domain_adminserver_address
	    adminserver_listen_on_all_interfaces:  true
	    adminserver_port:                      7101
	    nodemanager_port:                      5557
	    nodemanager_secure_listener:           false
	    weblogic_password:                     *domain_wls_password
	    jsse_enabled:                          *wls_jsse_enabled
	    log_dir:                               *wls_log_dir
        java_arguments:
            ADM:  "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
 

ADF with and without RCU

		domain_instances:
		  'adf_domain':
		     # domain_template:          "adf_restricted"
		     domain_template:          "adf"
		     repository_database_url:  "jdbc:oracle:thin:@wlsdb.example.com:1521/wlsrepos.example.com"
		     repository_prefix:        "DEV"
		     repository_password:      "Welcome01"
		     repository_sys_password:  "Welcome01"
		     rcu_database_url:         "wlsdb.example.com:1521:wlsrepos.example.com"
		     domain_name:              *domain_name
		     development_mode:         true
		     log_output:               *logoutput
		     webtier_enabled:          true
		     adminserver_address:      *domain_adminserver_address
		     weblogic_password:        *domain_wls_password
		     jsse_enabled:             *wls_jsse_enabled
		     log_dir:                  *wls_log_dir

		domain_instances:
		  'adf_domain':
		     domain_template:          "adf_restricted"
		     domain_name:              *domain_name
		     development_mode:         true
		     log_output:               *logoutput
		     webtier_enabled:          true
		     adminserver_address:      *domain_adminserver_address
		     weblogic_password:        *domain_wls_password
		     jsse_enabled:             *wls_jsse_enabled
		     log_dir:                  *wls_log_dir



Standalone Webtier

	logoutput:                &logoutput                true

	wls_oracle_base_home_dir: &wls_oracle_base_home_dir "/opt/oracle"
	wls_weblogic_user:        &wls_weblogic_user        "weblogic"
	wls_weblogic_home_dir:    &wls_weblogic_home_dir    "/opt/oracle/middleware12c/wlserver"
	wls_middleware_home_dir:  &wls_middleware_home_dir  "/opt/oracle/middleware12c"
	wls_version:              &wls_version              12212

	# global OS vars
	wls_os_user:              &wls_os_user              "oracle"
	wls_os_group:             &wls_os_group             "dba"
	wls_download_dir:         &wls_download_dir         "/var/tmp/install"
	wls_source:               &wls_source               "/software"
	wls_jdk_home_dir:         &wls_jdk_home_dir         "/usr/java/latest"
	wls_log_dir:              &wls_log_dir              "/var/log/weblogic"

	domain_name:                &domain_name                "Wls1221"
	domain_nodemanager_port:    &domain_nodemanager_port    5556
	domain_wls_password:        &domain_wls_password        "weblogic1"

	domain_adminserver_address: &domain_adminserver_address "10.10.10.36"

	domain_instances:
	  'Wls1221':
	    version:                               *wls_version
	    domain_template:                       "ohs_standalone"
	    development_mode:                      false
	    ohs_standalone_listen_address:         *domain_adminserver_address
	    ohs_standalone_listen_port:            8180
	    ohs_standalone_ssl_listen_port:        8181
	    nodemanager_password:                  *domain_wls_password
	    nodemanager_username:                  *wls_weblogic_user
	    log_output:                            *logoutput
	    weblogic_home_dir:                     *wls_weblogic_home_dir
	    middleware_home_dir:                   *wls_middleware_home_dir
	    jdk_home_dir:                          *wls_jdk_home_dir
	    domain_name:                           *domain_name
	    adminserver_address:                   *domain_adminserver_address
	    weblogic_password:                     *domain_wls_password
	    log_dir:                               *wls_log_dir
	    wls_domains_dir:                       ''
	    wls_apps_dir:                          ''
	    os_user:                               *wls_os_user
	    os_group:                              *wls_os_group
	    download_dir:                          *wls_download_dir

	nodemanager_instances:
	  'nodemanager':
	    ohs_standalone:                        true
	    log_output:                            *logoutput
	    log_file:                              'nodemanager_wls1221.log'
	    version:                               *wls_version
	    weblogic_home_dir:                     *wls_weblogic_home_dir
	    middleware_home_dir:                   *wls_middleware_home_dir
	    jdk_home_dir:                          *wls_jdk_home_dir
	    sleep:                                 21
	    domain_name:                           *domain_name
	    nodemanager_address:                   *domain_adminserver_address
	    wls_domains_dir:                       ''
	    os_user:                               *wls_os_user
	    os_group:                              *wls_os_group
	    download_dir:                          *wls_download_dir

	# startup adminserver for extra configuration
	control_instances:
	  'startOHS1server':
	    domain_name:                 *domain_name
	    server_type:                 'ohs_standalone'
	    target:                      'Server'
	    server:                      'ohs1'
	    action:                      'start'
	    log_output:                  *logoutput
	    wls_domains_dir:             ''
	    os_user:                     *wls_os_user
	    os_group:                    *wls_os_group
	    download_dir:                *wls_download_dir
	    weblogic_home_dir:           *wls_weblogic_home_dir
	    middleware_home_dir:         *wls_middleware_home_dir
	    jdk_home_dir:                *wls_jdk_home_dir
	    adminserver_address:         *domain_adminserver_address
	    weblogic_password:           *domain_wls_password      



### packdomain
__orawls::packdomain__ pack a WebLogic Domain and add this to the download folder

    $default_params = {}
    $pack_domain_instances = hiera('pack_domain_instances', {})
    create_resources('orawls::packdomain',$pack_domain_instances, $default_params)

	# pack domains
	pack_domain_instances:
	  'Wls1221':
	     weblogic_home_dir:           *wls_weblogic_home_dir 
	     domain_name:                 *domain_name
	  'plain':
	     weblogic_home_dir:           *wls_weblogic_home_dir 
	     domain_name:                 "plain_Wls"



### copydomain
__orawls::copydomain__ copies a WebLogic domain with SSH or from a share, unpack and enroll to a nodemanager

When using ssh (use_ssh = true) you need to setup ssh so you won't need to provide a password

    $default_params = {}
    $copy_instances = hiera('copy_instances', {})
    create_resources('orawls::copydomain',$copy_instances, $default_params)

	# copy domains to other nodes
	copy_instances:
	  'wlsDomain':
	     log_output:                *logoutput
	     weblogic_home_dir:         *wls_weblogic_home_dir 
	     domain_name:               *domain_name
	     jsse_enabled:              *wls_jsse_enabled
	     adminserver_address:       *domain_adminserver_address
	     weblogic_user:             'weblogic'
	     weblogic_password:         *domain_wls_password
	     server_start_mode:         'prod'
	     custom_trust:              *wls_custom_trust
	     trust_keystore_file:       *wls_trust_keystore_file
	     trust_keystore_passphrase: *wls_trust_keystore_passphrase


### nodemanager
__orawls::nodemanager__ start the nodemanager of a WebLogic Domain or Middleware Home


Same configuration but then with Hiera ( need to have puppet > 3.0 )

    $default = {}
    $nodemanager_instances = hiera('nodemanager_instances', [])
    create_resources('orawls::nodemanager',$nodemanager_instances, $default)

	nodemanager_instances:
	  'nodemanager':
	    weblogic_home_dir:                     *wls_weblogic_home_dir 
	    log_file:                              'nodemanager_wls1221.log'
	    extra_arguments:                       '-Daa=1 -Dbb=2'
	    custom_trust:                          *wls_custom_trust
	    trust_keystore_file:                   *wls_trust_keystore_file
	    trust_keystore_passphrase:             *wls_trust_keystore_passphrase
	    custom_identity:                       true
	    custom_identity_keystore_filename:     '/vagrant/identity_admin.jks'
	    custom_identity_keystore_passphrase:   'welcome'
	    custom_identity_alias:                 'admin'
	    custom_identity_privatekey_passphrase: 'welcome'
	    nodemanager_address:                   *domain_adminserver_address
	    domain_name:                           *domain_name
	    jsse_enabled:                          *wls_jsse_enabled
	    sleep:                                 21
	    properties:
	      'log_level':                         'INFO'
	      'log_count':                         '2'
	      'log_append':                        true
	      'log_formatter':                     'weblogic.nodemanager.server.LogFormatter'
	      'listen_backlog':                    60
	  'nodemanager_plain':
	    weblogic_home_dir:                     *wls_weblogic_home_dir 
	    log_file:                              'nodemanager_plain.log'
	    nodemanager_address:                   *domain_adminserver_address
	    nodemanager_port:                      5557
	    domain_name:                           "plain_Wls"
	    custom_trust:                          false
	    custom_identity:                       false
	    nodemanager_secure_listener:           false
	    sleep:                                 21
	    jsse_enabled:                          *wls_jsse_enabled

### control
__orawls::control__ start or stops the AdminServer,Managed Server, OHS Standalone Server or a Cluster of a WebLogic Domain, this will call the wls_managedserver, wls_adminserver and wls_ohsserver types


    $default = {}
    $control_instances = hiera('control_instances', {})
    create_resources('orawls::control',$control_instances, $default)

	control_instances:
	  'startWLSAdminServer':
	     weblogic_home_dir:           *wls_weblogic_home_dir 
	     domain_name:                 *domain_name
	     server_type:                 'admin'
	     target:                      'Server'
	     action:                      'start'
	     custom_trust:                *wls_custom_trust
	     trust_keystore_file:         *wls_trust_keystore_file
	     trust_keystore_passphrase:   *wls_trust_keystore_passphrase
	     jsse_enabled:                *wls_jsse_enabled
	     adminserver_address:         *domain_adminserver_address
	     weblogic_password:           *domain_wls_password                 
	  'startWLSAdminServer_plain':
	     weblogic_home_dir:           *wls_weblogic_home_dir 
	     domain_name:                 'plain_Wls'
	     server_type:                 'admin'
	     nodemanager_port:            5557
	     nodemanager_secure_listener: false
	     custom_trust:                false
	     target:                      'Server'
	     action:                      'start'
	     jsse_enabled:                *wls_jsse_enabled
	     adminserver_address:         *domain_adminserver_address
	     weblogic_password:           *domain_wls_password   



### urandomfix
__orawls::urandomfix__ Linux low on entropy or urandom fix can cause certain operations to be very slow. Encryption operations need entropy to ensure randomness. Entropy is generated by the OS when you use the keyboard, the mouse or the disk.

If an encryption operation is missing entropy it will wait until enough is generated.

three options
-  use rngd service (use this wls::urandomfix class)
-  set java.security in JDK ( jre/lib/security in my jdk7 module )
-  set -Djava.security.egd=file:/dev/./urandom param


### storeuserconfig
__orawls::storeuserconfig__ Creates WLST user config for WLST , this way you don't need to know the weblogic password.
when you set the defaults hiera variables


    notify { 'class userconfig':}
    $default_params = {}
    $userconfig_instances = hiera('userconfig_instances', {})
    create_resources('orawls::storeuserconfig',$userconfig_instances, $default_params)

	userconfig_instances:
	  'Wls1221':
	    user_config_dir:      '/home/oracle'
	    weblogic_home_dir:    *wls_weblogic_home_dir 
	    domain_name:          *domain_name
	    adminserver_address:  *domain_adminserver_address
	    weblogic_password:    *domain_wls_password   

### Dynamictargetting
Sometimes you do not know how many managed services you will have,
due to application scaling or other use cases. Since you do specify resources
like clusters and datasources in a more 'static' way, there should be a way to
qualify a managed server as a target for such resources.

We use the notes field in WebLogic Server to accomplish this. Currently implemented
for the following resource types:

- wls_cluster
- wls_datasource
- wls_mail_session

The way you use this, is by entering the resource name in the server_parameter
field on the wls_server type, and put the servers field to 'inherited' on the
resource to be targeted.

Example:

    wls_server { 'wlsServer1':
      ensure                            => 'present',
      arguments                         => '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer1.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer1_err.out',
      jsseenabled                       => '0',
      listenaddress                     => '10.10.10.100',
      listenport                        => '8001',
      listenportenabled                 => '1',
      machine                           => 'Node1',
      sslenabled                        => '0',
      tunnelingenabled                  => '0',
      max_message_size                  => '10000000',
      server_parameter                  => 'WebCluster, hrDs',
    }

    wls_cluster { 'WebCluster':
      ensure           => 'present',
      messagingmode    => 'unicast',
      migrationbasis   => 'consensus',
      servers          => ['inherited'],
      multicastaddress => '239.192.0.0',
      multicastport    => '7001',
    }

    wls_datasource { 'hrDS':
      ensure                           => 'present',
      connectioncreationretryfrequency => '0',
      drivername                       => 'oracle.jdbc.xa.client.OracleXADataSource',
      extraproperties                  => ['SendStreamAsBlob=true', 'oracle.net.CONNECT_TIMEOUT=10001'],
      fanenabled                       => '0',
      globaltransactionsprotocol       => 'TwoPhaseCommit',
      initialcapacity                  => '2',
      initsql                          => 'None',
      jndinames                        => ['jdbc/hrDS', 'jdbc/hrDS2'],
      maxcapacity                      => '15',
      mincapacity                      => '1',
      rowprefetchenabled               => '0',
      rowprefetchsize                  => '48',
      secondstotrustidlepoolconnection => '10',
      statementcachesize               => '10',
      target                           => ['inherited'],
      targettype                       => ['inherited'],
      testconnectionsonreserve         => '0',
      testfrequency                    => '120',
      testtablename                    => 'SQL SELECT 1 FROM DUAL',
      url                              => 'jdbc:oracle:thin:@dbagent2.alfa.local:1521/test.oracle.com',
      user                             => 'hr',
      usexa                            => '0',
    }

In the case of the wls_datasource type, the jdbc connection will be targetted on
the cluster if the managed server is in a cluster.


### Configure Oracle HTTP Server

You can configure OHS locations using __orawls::ohs::forwarder__ resource:

	ohs_forwarder_instances:
	  '/console':
	      servers:    ['10.10.10.10:7001']
	      os_user:     *wls_os_user
	      os_group:    *wls_os_group
	      domain_dir: '/opt/oracle/middleware12c/user_projects/domains/Wls1212'
	      require:     Orawls::Control[startOHS1server]
	      notify:      Wls_ohsserver[reloadOHS1server]

	# subscribe on a ohs change and restart the ohs server
	osh_reload_domain:
	  'reloadOHS1server':
	     ensure:                    'running'
	     domain_name:               *domain_name
	     server_name:               'ohs1'
	     domain_path:               '/opt/oracle/middleware12c/user_projects/domains/Wls1212'
	     os_user:                   *wls_os_user
	     weblogic_home_dir:         *wls_weblogic_home_dir
	     weblogic_user:             *wls_weblogic_user
	     weblogic_password:         *domain_wls_password
	     jdk_home_dir:              *wls_jdk_home_dir
	     nodemanager_address:       *domain_adminserver_address
	     nodemanager_port:          *domain_nodemanager_port
	     refreshonly:               true

Notify option is needed to OHS restart and load changes. Require is needed because, without it, notify option may attempt to reload server before it's running.

OHS will include all __.conf__ files at ${domain_path}/config/fmwconfig/components/OHS/${server_name}/mod_wl_ohs.d folder.


### fmwlogdir
__orawls::fmwlogdir__ Change a log folder location of a FMW server

    $default_params = {}
    $fmwlogdir_instances = hiera('fmwlogdir_instances', {})
    create_resources('orawls::fmwlogdir',$fmwlogdir_instances, $default_params)

	fmwlogdir_instances:
	  'AdminServer':
	     server:               'AdminServer'
	     weblogic_user:        *wls_weblogic_user
	     weblogic_password:    *domain_wls_password
	     adminserver_address:  *domain_adminserver_address
	     log_dir:              *wls_log_dir
	     require:              Orawls::Utils::Fmwclusterjrf[WebCluster]
	  'WebServer1':
	     server:              'WebServer1'
	     weblogic_user:        *wls_weblogic_user
	     weblogic_password:    *domain_wls_password
	     adminserver_address:  *domain_adminserver_address
	     log_dir:              *wls_log_dir
	     require:              Orawls::Utils::Fmwclusterjrf[WebCluster]



### resourceadapter
__orawls::resourceadapter__ Add a Resource adapter plan for File, FTP, AQ, MQ, DB or JMS with some entries
when you set the defaults hiera variables

    $default_params = {}
    $resource_adapter_instances = hiera('resource_adapter_instances', {})
    create_resources('orawls::resourceadapter',$resource_adapter_instances, $default_params)

	resource_adapter_instances:
	  'JmsAdapter_hr':
	    adapter_name:              'JmsAdapter'
	    adapter_path:              "/opt/oracle/middleware12c/soa/soa/connectors/JmsAdapter.rar"
	    adapter_plan_dir:          "/opt/oracle/middleware12c"
	    adapter_plan:              'Plan_JMS.xml'
	    adapter_entry:             'eis/JMS/cf'
	    adapter_entry_property:    'ConnectionFactoryLocation'
	    adapter_entry_value:       'jms/cf'
	    domain_name:                *domain_name
	    weblogic_password:          *domain_wls_password                 
	    adminserver_address:        *domain_adminserver_address
	  'JmsAdapter_hr2':
	    adapter_name:              'JmsAdapter'
	    adapter_path:              "/opt/oracle/middleware12c/soa/soa/connectors/JmsAdapter.rar"
	    adapter_plan_dir:          "/opt/oracle/middleware12c"
	    adapter_plan:              'Plan_JMS.xml'
	    adapter_entry:             'eis/JMS/cf2'
	    adapter_entry_property:    'ConnectionFactoryLocation'
	    adapter_entry_value:       'jms/cf2'
	    domain_name:                *domain_name
	    weblogic_password:          *domain_wls_password                 
	    adminserver_address:        *domain_adminserver_address
	  'AqAdapter_hr':
	    adapter_name:              'AqAdapter'
	    adapter_path:              "/opt/oracle/middleware12c/soa/soa/connectors/AqAdapter.rar"
	    adapter_plan_dir:          "/opt/oracle/middleware12c"
	    adapter_plan:              'Plan_AQ.xml'
	    adapter_entry:             'eis/AQ/hr'
	    adapter_entry_property:    'XADataSourceName'
	    adapter_entry_value:       'jdbc/hrDS'
	    domain_name:                *domain_name
	    weblogic_password:          *domain_wls_password                 
	    adminserver_address:        *domain_adminserver_address
	  'DbAdapter_hr':
	    adapter_name:              'DbAdapter'
	    adapter_path:              "/opt/oracle/middleware12c/soa/soa/connectors/DbAdapter.rar"
	    adapter_plan_dir:          "/opt/oracle/middleware12c"
	    adapter_plan:              'Plan_DB.xml'
	    adapter_entry:             'eis/DB/hr'
	    adapter_entry_property:    'XADataSourceName'
	    adapter_entry_value:       'jdbc/hrDS'
	    domain_name:                *domain_name
	    weblogic_password:          *domain_wls_password                 
	    adminserver_address:        *domain_adminserver_address
	  'DbAdapter_hr2':
	    adapter_name:              'DbAdapter'
	    adapter_path:              "/opt/oracle/middleware12c/soa/soa/connectors/DbAdapter.rar"
	    adapter_plan_dir:          "/opt/oracle/middleware12c"
	    adapter_plan:              'Plan_DB.xml'
	    adapter_entry:             'eis/DB/hr2'
	    adapter_entry_property:    'xADataSourceName'
	    adapter_entry_value:       'jdbc/hrDS2'
	    log_output:                *logoutput
	    domain_name:                *domain_name
	    weblogic_password:          *domain_wls_password                 
	    adminserver_address:        *domain_adminserver_address
	  'FTPAdapter_hr':
	    adapter_name:              'FtpAdapter'
	    adapter_path:              "/opt/oracle/middleware12c/soa/soa/connectors/FtpAdapter.rar"
	    adapter_plan_dir:          "/opt/oracle/middleware12c"
	    adapter_plan:              'Plan_FTP.xml'
	    adapter_entry:             'eis/FTP/xx'
	    adapter_entry_property:    'FtpAbsolutePathBegin;FtpPathSeparator;Host;ListParserKey;Password;ServerType;UseFtps;Username;UseSftp'
	    adapter_entry_value:       '/BDDC;/;l2-ibrfongen02.nl.rsg;UNIX;;unix;false;kim;false'
	    domain_name:                *domain_name
	    weblogic_password:          *domain_wls_password                 
	    adminserver_address:        *domain_adminserver_address
	  'FileAdapter_hr':
	    adapter_name:              'FileAdapter'
	    adapter_path:              "/opt/oracle/middleware12c/soa/soa/connectors/FileAdapter.rar"
	    adapter_plan_dir:          "/opt/oracle/middleware12c"
	    adapter_plan:              'Plan_FILE.xml'
	    adapter_entry:             'eis/FileAdapterXX'
	    adapter_entry_property:    'ControlDir;IsTransacted'
	    adapter_entry_value:       '/tmp/aaa;false'
	    domain_name:                *domain_name
	    weblogic_password:          *domain_wls_password                 
	    adminserver_address:        *domain_adminserver_address



### fmwcluster
__orawls::utils::fmwcluster__ convert existing cluster to a OSB or SOA suite cluster (BPM is optional) and also convert BAM to a BAM cluster. This will also work for OIM / OAM cluster.
The security store is migrated to a database store during this conversion. To maintain a file based store set a standalone hiera param "retain_security_file_store" to true.

You first need to create some OSB, SOA or BAM clusters and add some managed servers to these clusters
for OSB 11g or SOA Suite 11g managed servers make sure to also set the coherence arguments parameters

    $default_params = {}
    $fmw_cluster_instances = hiera('fmw_cluster_instances', $default_params)
    create_resources('orawls::utils::fmwcluster',$fmw_cluster_instances, $default_params)

    # FMW 11g cluster
    fmw_cluster_instances:
      'soaCluster':
         domain_name:          "soa_domain"
         soa_cluster_name:     "SoaCluster"
         bam_cluster_name:     "BamCluster"
         osb_cluster_name:     "OsbCluster"
         log_output:           *logoutput
         bpm_enabled:          true
         bam_enabled:          true
         soa_enabled:          true
         osb_enabled:          true
         repository_prefix:    "DEV"
	     weblogic_user:        *wls_weblogic_user
	     weblogic_password:    *domain_wls_password
	     adminserver_address:  *domain_adminserver_address

    # FMW 12.1.3 cluster
    fmw_cluster_instances:
      'soaCluster':
        domain_name:          "soa_domain"
        soa_cluster_name:     "SoaCluster"
        bam_cluster_name:     "BamCluster"
        osb_cluster_name:     "OsbCluster"
        ess_cluster_name:     "EssCluster" # optional else ESS will be added to the soa cluster
        log_output:           *logoutput
        bpm_enabled:          true
        bam_enabled:          true
        soa_enabled:          true
        osb_enabled:          true
        b2b_enabled:          true
        ess_enabled:          true
        repository_prefix:    "DEV"
	    weblogic_user:        *wls_weblogic_user
	    weblogic_password:    *domain_wls_password
	    adminserver_address:  *domain_adminserver_address

	fmw_cluster_instances:
	  'soaCluster':
	    domain_name:          "soa_domain"
	    soa_cluster_name:     "SoaCluster"
	    bam_cluster_name:     "BamCluster"
	    osb_cluster_name:     "OsbCluster"
	    bpm_enabled:          true
	    bam_enabled:          true
	    soa_enabled:          true
	    osb_enabled:          true
	    b2b_enabled:          true
	    ess_enabled:          true
	    repository_prefix:    "DEV6"
	    weblogic_user:        *wls_weblogic_user
	    weblogic_password:    *domain_wls_password
	    adminserver_address:  *domain_adminserver_address

    # OIM 11.1.2.3 cluster
    fmw_cluster_instances:
      'oimCluster':
        domain_name:          *domain_name
        soa_cluster_name:     "SoaCluster"
        oim_cluster_name:     "OimCluster"
        oam_cluster_name:     "OamCluster"
        bi_cluster_name:      "BiCluster"
        log_output:           *logoutput
        soa_enabled:          true
        oim_enabled:          true
        oam_enabled:          true
        bi_enabled:           true
        repository_prefix:    *rcu_prefix


### fmwclusterjrf
__orawls::utils::fmwclusterjrf__ convert existing cluster to a ADF/JRF cluster
you need to create a wls cluster with some managed servers first

    $default_params = {}
    $fmw_jrf_cluster_instances = hiera('fmw_jrf_cluster_instances', $default_params)
    create_resources('orawls::utils::fmwclusterjrf',$fmw_jrf_cluster_instances, $default_params)

	fmw_jrf_cluster_instances:
	  'WebCluster':
	     domain_name:          "adf_domain"
	     jrf_target_name:      "WebCluster"
	     opss_datasource_name: "opss-data-source"
	     log_output:           *logoutput
	     weblogic_user:        *wls_weblogic_user
	     weblogic_password:    *domain_wls_password
	     adminserver_address:  *domain_adminserver_address


### webtier
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

Webtier for OAM

    webtier_instances:
      'ohs1':
        action_name:            'create'
        instance_name:          'ohs1'
        webgate_configure:      true
        webgate_agentname:      'ohs1'
        webgate_hostidentifier: 'host1'
        oamadminserverhostname: 'oim1admin.example.com'
        oamadminserverport:     '7001'
        log_output:             *logoutput

### oimconfig
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
        bi_cluster_name:            'BiCluster'
        bi_enabled:                 true
        remote_config:              false
        keystore_password:          'Welcome01'
        design_config:              false
        oimserver_hostname:         'oim1admin.example.com'
        oimserver_port:             '14000'
        soaserver_name:             'SoaServer1'
        oimserver_name:             'OimServer1'
        repository_database_url:    "oimdb.example.com:1521:oimrepos.example.com"
        repository_prefix:          *rcu_prefix
        repository_password:        "Welcome01"

### instance
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

### oud_control
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

## Types and providers

All wls types needs a wls_setting definition, this is a pointer to an WebLogic AdminServer and you need to create one for every WebLogic domain. When you don't provide a wls_setting identifier in the title of the weblogic type then it will use default as identifier.

Global timeout parameter for WebLogic resource types. use timeout and value in seconds, default = 120 seconds or 2 minutes

###wls_setting

required for all the weblogic type/providers, this is a pointer to an WebLogic AdminServer.

    wls_setting { 'default':
      user                         => 'oracle',
      weblogic_home_dir            => '/opt/oracle/middleware11g/wlserver_10.3',
      connect_url                  => "t3://localhost:7001",
      weblogic_user                => 'weblogic',
      weblogic_password            => 'weblogic1',
      use_default_value_when_empty => true
    }

    wls_setting { 'domain2':
      user                         => 'oracle',
      weblogic_home_dir            => '/opt/oracle/middleware11g/wlserver_10.3',
      connect_url                  => "t3://localhost:7011",
      weblogic_user                => 'weblogic',
      weblogic_password            => 'weblogic1',
      post_classpath               => '/opt/oracle/wlsdomains/domains/Wls1036/lib/aa.jar',
      use_default_value_when_empty => false
    }

use_default_value_when_empty = true when you want to make sure the wls type properties will set its default mbean values when it is not provided by your puppet configuration.
So when you set a wls type properties and remove it again it will set it back to its original value ( off course only when it has one)


saving the WLST scripts of all the wls types to a temporary folder

archive_path has /tmp/orawls-archive as default folder

    wls_setting { 'default':
      debug_module              => 'true',
      archive_path              => '/var/tmp/install/default_domain',
      connect_url               => 't3s://10.10.10.10:7002',
      custom_trust              => 'true',
      trust_keystore_file       => '/vagrant/truststore.jks',
      trust_keystore_passphrase => 'welcome',
      user                      => 'oracle',
      weblogic_home_dir         => '/opt/oracle/middleware12c/wlserver',
      weblogic_password         => 'weblogic1',
      weblogic_user             => 'weblogic',
    }
    wls_setting { 'plain':
      debug_module      => 'false',
      archive_path      => '/tmp/orawls-archive',
      connect_url       => 't3://10.10.10.10:7101',
      custom_trust      => 'false',
      user              => 'oracle',
      weblogic_home_dir => '/opt/oracle/middleware12c/wlserver',
      weblogic_password => 'weblogic1',
      weblogic_user     => 'weblogic',
    }

or in hiera

    # and for with weblogic infra 12.2.1, use this post_classpath
    wls_setting_instances:
      'default':
        user:               'oracle'
        weblogic_home_dir:  '/opt/oracle/middleware12c/wlserver'
        connect_url:        "t3://10.10.10.21:7001"
        weblogic_user:      'weblogic'
        weblogic_password:  'weblogic1'
        post_classpath:     '/opt/oracle/middleware12c/oracle_common/modules/internal/features/jrf_wlsFmw_oracle.jrf.wlst.jar'
        extra_arguments:    '-Daa=1 -Dbb=2'


    # and for with weblogic infra 12.1.3, use this post_classpath
    wls_setting_instances:
      'default':
        user:               'oracle'
        weblogic_home_dir:  '/opt/oracle/middleware12c/wlserver'
        connect_url:        "t3://10.10.10.21:7001"
        weblogic_user:      'weblogic'
        weblogic_password:  'weblogic1'
        post_classpath:     '/opt/oracle/middleware12c/oracle_common/modules/internal/features/jrf_wlsFmw_oracle.jrf.wlst_12.1.3.jar'
        extra_arguments:    '-Daa=1 -Dbb=2'

    wls_setting_instances:
      'default':
        user:                      *wls_os_user
        weblogic_home_dir:         *wls_weblogic_home_dir
        connect_url:               "t3s://%{hiera('domain_adminserver_address')}:7002"
        weblogic_user:             *wls_weblogic_user
        weblogic_password:         *domain_wls_password
        custom_trust:              *wls_custom_trust
        trust_keystore_file:       *wls_trust_keystore_file
        trust_keystore_passphrase: *wls_trust_keystore_passphrase
        require:                   Orawls::Domain[Wls1213]
        debug_module:              true
        archive_path:              '/var/tmp/install/default_domain'
      'plain':
        user:                      *wls_os_user
        weblogic_home_dir:         *wls_weblogic_home_dir
        connect_url:               "t3://%{hiera('domain_adminserver_address')}:7101"
        weblogic_user:             *wls_weblogic_user
        weblogic_password:         *domain_wls_password
        require:                   Orawls::Domain[plain_Wls]
        debug_module:              false



With t3s and custom trust

    wls_setting_instances:
      'default':
        user:                      oracle'
        weblogic_home_dir:         '/opt/oracle/middleware12c/wlserver'
        connect_url:               "t3s://10.10.10.21:7002"
        weblogic_user:             'weblogic'
        weblogic_password:         'weblogic1'
        custom_trust:              true
        trust_keystore_file:       '/vagrant/truststore.jks'
        trust_keystore_passphrase: 'welcome'
      'plain':
        user:                      oracle'
        weblogic_home_dir:         '/opt/oracle/middleware12c/wlserver'
        connect_url:               "t3://10.10.10.21:7101"
        weblogic_user:             'weblogic'
        weblogic_password:         'weblogic1'


### wls_domain

it needs wls_setting and when identifier is not provided it will use the 'default'. Probably after changing the domain you need to restart the AdminServer or subscribe for a restart to this change with the wls_adminserver type

or use puppet resource wls_domain

    # In this case it will use default as wls_setting identifier
    wls_domain { 'Wls1036':
      ensure                                            => 'present',
      jmx_platform_mbean_server_enabled                 => '1',
      jmx_platform_mbean_server_used                    => '1',
      jpa_default_provider                              => 'org.eclipse.persistence.jpa.PersistenceProvider',
      jta_max_transactions                              => '20000',
      jta_transaction_timeout                           => '35',
      log_file_min_size                                 => '5000',
      log_filecount                                     => '10',
      log_filename                                      => '/var/log/weblogic/Wls1036.log',
      log_number_of_files_limited                       => '1',
      log_rotate_logon_startup                          => '1',
      log_rotationtype                                  => 'bySize',
      security_crossdomain                              => '0',
      web_app_container_show_archived_real_path_enabled => '1',
    }

    wls_domain { 'Wls11gSetting/Wls11g':
      ensure                                            => 'present',
      jmx_platform_mbean_server_enabled                 => '0',
      jmx_platform_mbean_server_used                    => '1',
      jpa_default_provider                              => 'org.apache.openjpa.persistence.PersistenceProviderImpl',
      jta_max_transactions                              => '10000',
      jta_transaction_timeout                           => '30',
      log_file_min_size                                 => '5000',
      log_filecount                                     => '5',
      log_filename                                      => '/var/log/weblogic/Wls11g.log',
      log_number_of_files_limited                       => '0',
      log_rotate_logon_startup                          => '0',
      log_rotationtype                                  => 'byTime',
      security_crossdomain                              => '1',
      web_app_container_show_archived_real_path_enabled => '0',
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


### wls_adminserver

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

subscribe to a wls_domain, wls_authenticaton_provider or wls_identity_asserter event

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

### wls_managedserver

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


subscribe to a wls_domain, wls_identity_asserter or wls_authenticaton_provider event

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

### wls_ohsserver

type for ohs server control like start, running, abort and stop.
also supports subscribe with refreshonly


    # for this type you won't need a wls_setting identifier
    wls_ohsserver{'OHS Server:':
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

### wls_deployment

it needs wls_setting and when identifier is not provided it will use the 'default'.
or use puppet resource wls_deployment


    # 'jersey-bundle' will use default as wls_setting identifier
    wls_deployment { 'jersey-bundle':
      ensure            => 'present',
      deploymenttype    => 'Library',
      stagingmode       => 'nostage',
      remote            => "1",
      upload            => "1",
      target            => ['AdminServer', 'WebCluster'],
      targettype        => ['Server', 'Cluster'],
      versionidentifier => '1.18@1.18.0.0',
    }

    wls_deployment { 'webapp':
      ensure            => 'present',
      deploymenttype    => 'AppDeployment',
      stagingmode       => 'nostage',
      remote            => "1",
      upload            => "1",
      target            => ['WebCluster'],
      targettype        => ['Cluster'],
      versionidentifier => '1.1@1.1.0.0',
      require           => Wls_deployment['jersey-bundle']
    }


in hiera

    $default_params = {}
    $deployment_instances = hiera('deployment_instances', $default_params)
    create_resources('wls_deployment',$deployment_instances, $default_params)

    deployment_instances:
      'jersey-bundle':
        ensure:            'present'
        deploymenttype:    'Library'
        versionidentifier: '1.18@1.18.0.0'
        timeout:           60
        stagingmode:       "nostage"
        remote:            "1"
        upload:            "1"
        target:
          - 'AdminServer'
          - 'WebCluster'
        targettype:
          - 'Server'
          - 'Cluster'
        localpath:         '/vagrant/jersey-bundle-1.18.war'
        require:
           - Wls_cluster[WebCluster]
      'webapp':
        ensure:            'present'
        deploymenttype:    'AppDeployment'
        versionidentifier: '1.1@1.1.0.0'
        timeout:           60
        stagingmode:       "nostage"
        remote:            "1"
        upload:            "1"
        target:
          - 'WebCluster'
        targettype:
          - 'Cluster'
        localpath:         '/vagrant/webapp.war'
        require:
           - Wls_deployment[jersey-bundle]
           - Wls_cluster[WebCluster]


### wls_user

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

### wls_group

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

### wls_role

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_role

    # this will use default as wls_setting identifier
    wls_role { 'default/Deployer':
      ensure     => 'present',
      expression => 'Grp(Deployers)',
      realm      => 'myrealm',
    }

    wls_role { 'default/OracleSystemRole':
      ensure     => 'present',
      expression => 'Grp(OracleSystemGroup)',
      realm      => 'myrealm',
    }

    wls_role { 'default/Admin':
      ensure     => 'present',
      expression => '?weblogic.entitlement.rules.AdministrativeGroup(Administrators)',
      realm      => 'myrealm',
    }

    wls_role { 'default/Anonymous':
      ensure     => 'present',
      expression => 'Grp(everyone)',
      realm      => 'myrealm',
    }

### wls_authentication_provider

it needs wls_setting and when identifier is not provided it will use the 'default' and probably after the creation the AdminServer needs a reboot or subscribe to a restart with the wls_adminserver type

only control_flag is a property, the rest are parameters and only used in a create action

Optionally, providers can be ordered by providing a value to the order paramater, which is a zero-based list. When configuring ordering order, it may be necessary to create the resources with Puppet ordering (if not using Hiera) or by structuring Hiera in matching order. Otherwise ordering may fail if not all authentication providers are created yet (by default the provider will be ordered last if it is greater than the number of providers currently configured).

To manage Weblogic's DefaultIdentityAsserter use the wls_identity_asserter type.

or use puppet resource wls_authentication_provider


    # this will use default as wls_setting identifier
    wls_authentication_provider { 'DefaultAuthenticator':
      ensure       => 'present',
      control_flag => 'SUFFICIENT',
    }

    # this provider will be ordered first in the providers list
    wls_authentication_provider { 'ldap':
      ensure            => 'present',
      control_flag      => 'SUFFICIENT',
      providerclassname => 'weblogic.security.providers.authentication.LDAPAuthenticator',
      provider_specific => {
           'Principal'                     => 'ldapuser',
           'Host'                          => 'ldapserver',
           'Port'                          => 389,
           'CacheTTL'                      => 60,
           'CacheSize'                     => 1024,
           'MaxGroupMembershipSearchLevel' => 4,
           'SSLEnabled'                    => 1,
      }
      order             =>  '0'
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


    #ldap will be the first listed provider
      'ldap':
        ensure:             'present'
        control_flag:       'SUFFICIENT'
        providerclassname:  'weblogic.security.providers.authentication.LDAPAuthenticator'
        provider_specific:
          'Principal':                     'ldapuser'
          'Host':                          'ldapserver'
          'Port':                          389
          'CacheTTL':                      60
          'CacheSize':                     1024
          'MaxGroupMembershipSearchLevel': 4
          'SSLEnabled':                    1
          'ConnectTimeout':                2
          'ConnectionRetryLimit':          2
        order:              '1'
        before:             Wls_domain[Wls1036]
      'ActiveDirectoryAuthenticator':
        ensure:             'present'
        control_flag:       'SUFFICIENT'
        providerclassname:  'weblogic.security.providers.authentication.ActiveDirectoryAuthenticator'
        provider_specific:
          'Credential':                     'password'
          'GroupBaseDN':                    'DC=ad,DC=company,DC=org'
          'GroupFromNameFilter':            '(&(sAMAccountName=%g)(objectclass=group))'
          'GroupMembershipSearching':       'limited'
          'Host':                           'ad.company.org'
          'MaxGroupMembershipSearchLevel':  4
          'Principal':                      'CN=SER_WASadmin,OU=Service Accounts,DC=ad,DC=company,DC=org'
          'UserBaseDN':                     'DC=ad,DC=company,DC=org'
          'UserFromNameFilter':             '(&(sAMAccountName=%u)(objectclass=user))'
          'UserNameAttribute':              'sAMAccountName'
          'Port':                           389
          'CacheTTL':                       60
          'CacheSize':                      1024
          'ConnectTimeout':                 2
          'ConnectionRetryLimit':           2
        order:              '2'

### wls_identity_asserter

it needs wls_setting and when identifier is not provided it will use the 'default' and probably after the creation the AdminServer needs a reboot or subscribe to a restart with the wls_adminserver type

to provide a list of token types to create provide a "::" seperated list for attribute 'ActiveTypes'

Optionally, the provider can be ordered by specifying a value to the order paramater, which is a zero-based list. When configuring ordering order, it may be necessary to create the resources with Puppet ordering (if not using Hiera) or by structuring Hiera in matching order. Otherwise ordering may fail if not all authentication providers are created yet (by default the provider will be ordered last if it is greater than the number of providers currently configured).

or use puppet resource wls_identity_asserter

    wls_authentication_provider { 'DefaultIdentityAsserter':
      ensure            => 'present',
      providerclassname => 'weblogic.security.providers.authentication.DefaultIdentityAsserter',
      attributes:       => 'DigestReplayDetectionEnabled;UseDefaultUserNameMapper',
      attributesvalues  => '1;1;',
      activetypes       => 'AuthenticatedUser::X.509',
      defaultmappertype => 'CN',
    }

in hiera

    $default_params = {}
    $identity_asserter_instances = hiera('identity_asserter_instances', {})
    create_resources('wls_identity_asserter',$identity_asserter_instances, $default_params)

    identity_asserter_instances:
      'DefaultIdentityAsserter':
        order:              '3'
        ensure:             'present'
        providerclassname:  'weblogic.security.providers.authentication.DefaultIdentityAsserter'
        attributes:         'DigestReplayDetectionEnabled;UseDefaultUserNameMapper'
        attributesvalues:   '1;1'
        activetypes:        'AuthenticatedUser::X.509'
        defaultmappertype:  'CN'

### wls_machine

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


### wls_server

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_server

    # this will use default as wls_setting identifier
    wls_server { 'wlsServer1':
      ensure                            => 'present',
      arguments                         => '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer1.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer1_err.out',
      jsseenabled                       => '0',
      listenaddress                     => '10.10.10.100',
      listenport                        => '8001',
      listenportenabled                 => '1',
      machine                           => 'Node1',
      sslenabled                        => '0',
      tunnelingenabled                  => '0',
      max_message_size                  => '10000000',
    }

or with log parameters, default file store and ssl

    # this will use default as wls_setting identifier
    wls_server { 'default/wlsServer2':
      ensure                            => 'present',
      arguments                         => '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer2.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer2_err.out',
      jsseenabled                       => '0',
      listenaddress                     => '10.10.10.200',
      listenport                        => '8001',
      listenportenabled                 => '1',
      log_file_min_size                 => '2000',
      log_filecount                     => '10',
      log_number_of_files_limited       => '1',
      log_rotate_logon_startup          => '1',
      log_rotationtype                  => 'bySize',
      logfilename                       => '/var/log/weblogic/wlsServer2.log',
      log_datasource_filename           => 'logs/datasource.log',
      log_http_filename                 => 'logs/access.log',
      log_http_format                   => 'date time cs-method cs-uri sc-status',
      log_http_format_type              => 'common',
      log_http_file_count               => '10',
      log_http_number_of_files_limited  => '0',
      log_redirect_stderr_to_server     => '0',
      log_redirect_stdout_to_server     => '0',
      logintimeout                      => '5000',
      restart_max                       => '2',
      machine                           => 'Node2',
      sslenabled                        => '1',
      sslhostnameverificationignored    => '1',
      ssllistenport                     => '8201',
      two_way_ssl                       => '0',
      client_certificate_enforced       => '0',
      default_file_store                => '/path/to/default_file_store/',
      max_message_size                  => '25000000',
      weblogic_plugin_enabled           => '1',
    }

If you want automatic restart when the server crashes, or automatically kill when the server hangs

    # this will use default as wls_setting identifier
    wls_server { 'wlsServer1':
      ensure                            => 'present',
      arguments                         => '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer1.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer1_err.out',
      jsseenabled                       => '0',
      listenaddress                     => '10.10.10.100',
      listenport                        => '8001',
      listenportenabled                 => '1',
      machine                           => 'Node1',
      sslenabled                        => '0',
      tunnelingenabled                  => '0',
      max_message_size                  => '10000000',
      auto_restart                      => '1',
      autokillwfail                     => '1',
    }

or with JSSE with custom identity and trust

    # this will use domain2 as wls_setting identifier
    wls_server { 'domain2/wlsServer2':
      ensure                                => 'present',
      arguments                             => '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/var/log/weblogic/wlsServer2.out -Dweblogic.Stderr=/var/log/weblogic/wlsServer2_err.out',
      listenaddress                         => '10.10.10.200',
      listenport                            => '8001',
      listenportenabled                     => '1',
      log_file_min_size                     => '2000',
      log_filecount                         => '10',
      log_number_of_files_limited           => '1',
      log_rotate_logon_startup              => '1',
      log_rotationtype                      => 'bySize',
      logfilename                           => '/var/log/weblogic/wlsServer2.log',
      machine                               => 'Node2',
      sslenabled                            => '1',
      sslhostnameverifier                   => 'None',
      sslhostnameverificationignored        => '1',
      ssllistenport                         => '8201',
      two_way_ssl                           => '0'
      client_certificate_enforced           => '0'
      jsseenabled                           => '1',
      custom_identity                       => '1',
      custom_identity_alias                 => 'node2',
      custom_identity_keystore_filename     => '/vagrant/identity_node2.jks',
      custom_identity_keystore_passphrase   => 'welcome',
      custom_identity_privatekey_passphrase => 'welcome',
      trust_keystore_file                   => '/vagrant/truststore.jks',
      trust_keystore_passphrase             => 'welcome',
      max_message_size                      => '25000000',
    }


in hiera

    # this will use default as wls_setting identifier
    server_instances:
      'wlsServer1':
         ensure:                         'present'
         arguments:                      '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer1.out -Dweblogic.Stderr=/data/logs/wlsServer1_err.out'
         listenaddress:                  '10.10.10.100'
         listenport:                     '8001'
         listenportenabled:              '1'
         logfilename:                    '/data/logs/wlsServer1.log'
         machine:                        'Node1'
         sslenabled:                     '1'
         jsseenabled:                    '0'
         ssllistenport:                  '8201'
         sslhostnameverificationignored: '1'
         two_way_ssl:                    '0'
         client_certificate_enforced:    '0'

or with log parameters

    # this will use default as wls_setting identifier
    server_instances:
      'wlsServer1':
        ensure:                         'present'
        arguments:                      '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer1.out -Dweblogic.Stderr=/data/logs/wlsServer1_err.out'
        listenaddress:                         '10.10.10.100'
        listenport:                            '8001'
        listenportenabled:                     '1'
        logfilename:                           '/var/log/weblogic/wlsServer1.log'
        log_file_min_size:                     '2000'
        log_filecount:                         '10'
        log_number_of_files_limited:           '1'
        log_rotate_logon_startup:              '1'
        log_rotationtype:                      'bySize'
        log_datasource_filename:               'logs/datasource.log'
        log_http_filename:                     'logs/access.log'
        log_http_file_count:                   '10'
        log_http_number_of_files_limited:      '0'
        log_redirect_stderr_to_server:         '0'
        log_redirect_stdout_to_server:         '0'
        logintimeout:                          '5000'
        restart_max:                           '2'
        machine:                               'Node1'
        sslenabled:                            '1'
        ssllistenport:                         '8201'
        sslhostnameverificationignored:        '1'
        jsseenabled:                           '1'
        default_file_store:                    '/path/to/default_file_store/'
        max_message_size:                      '25000000'



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
        sslhostnameverifier:                   'None'
        useservercerts:                        '0'
        jsseenabled:                           '1'
        custom_identity:                       '1'
        custom_identity_keystore_filename:     '/vagrant/identity_node1.jks'
        custom_identity_keystore_passphrase:   'welcome'
        custom_identity_alias:                 'node1'
        custom_identity_privatekey_passphrase: 'welcome'
        trust_keystore_file:                   *wls_trust_keystore_file
        trust_keystore_passphrase:             *wls_trust_keystore_passphrase


### wls_server_channel

it needs wls_setting and when identifier is not provided it will use the 'default', the title must also contain the server name

or use puppet resource wls_server_channel

    # this will use default as wls_setting identifier
    wls_server_channel { 'default/wlsServer1:Channel-Cluster':
      ensure                      => 'present',
      channel_identity_customized => '0',
      client_certificate_enforced => '0',
      custom_identity_alias       => 'node1',
      enabled                     => '1',
      httpenabled                 => '1',
      listenaddress               => '10.10.10.100',
      listenport                  => '8003',
      max_message_size            => '25000000',
      outboundenabled             => '0',
      protocol                    => 'cluster-broadcast',
      publicaddress               => '10.10.10.100',
      publicport                  => '8003',
      tunnelingenabled            => '0',
      two_way_ssl                 => '0',
    }
    wls_server_channel { 'default/wlsServer1:HTTP':
      ensure                      => 'present',
      channel_identity_customized => '0',
      client_certificate_enforced => '0',
      custom_identity_alias       => 'node1',
      enabled                     => '1',
      httpenabled                 => '1',
      listenport                  => '8004',
      max_message_size            => '35000000',
      outboundenabled             => '0',
      protocol                    => 'http',
      publicport                  => '8104',
      tunnelingenabled            => '0',
      two_way_ssl                 => '0',
    }
    wls_server_channel { 'default/wlsServer2:Channel-Cluster':
      ensure                      => 'present',
      channel_identity_customized => '0',
      client_certificate_enforced => '0',
      custom_identity_alias       => 'node2',
      enabled                     => '1',
      httpenabled                 => '1',
      listenaddress               => '10.10.10.200',
      listenport                  => '8003',
      max_message_size            => '25000000',
      outboundenabled             => '0',
      protocol                    => 'cluster-broadcast',
      publicaddress               => '10.10.10.200',
      publicport                  => '8003',
      tunnelingenabled            => '0',
      two_way_ssl                 => '0',
    }
    wls_server_channel { 'default/wlsServer2:HTTP':
      ensure                      => 'present',
      channel_identity_customized => '0',
      client_certificate_enforced => '0',
      custom_identity_alias       => 'node2',
      enabled                     => '1',
      httpenabled                 => '1',
      listenport                  => '8004',
      max_message_size            => '35000000',
      outboundenabled             => '0',
      protocol                    => 'http',
      publicport                  => '8104',
      tunnelingenabled            => '0',
      two_way_ssl                 => '0',
    }

in hiera

    # this will use default as wls_setting identifier
    server_channel_instances:
      'wlsServer1:Channel-Cluster':
        ensure:           'present'
        enabled:          '1'
        httpenabled:      '1'
        listenaddress:    *domain_node1_address
        listenport:       '8003'
        outboundenabled:  '0'
        protocol:         'cluster-broadcast'
        publicaddress:    *domain_node1_address
        tunnelingenabled: '0'
        # require:
        #   - Wls_server[wlsServer1]
      'wlsServer2:Channel-Cluster':
        ensure:           'present'
        enabled:          '1'
        httpenabled:      '1'
        listenaddress:    *domain_node2_address
        listenport:       '8003'
        outboundenabled:  '0'
        protocol:         'cluster-broadcast'
        publicaddress:    *domain_node2_address
        tunnelingenabled: '0'
        # require:
        #   - Wls_server[wlsServer2]
      'wlsServer1:HTTP':
        ensure:           'present'
        enabled:          '1'
        httpenabled:      '1'
        listenport:       '8004'
        publicport:       '8104'
        outboundenabled:  '0'
        protocol:         'http'
        tunnelingenabled: '0'
        max_message_size: '35000000'
        # require:
        #   - Wls_server[wlsServer1]
      'wlsServer2:HTTP':
        ensure:           'present'
        enabled:          '1'
        httpenabled:      '1'
        listenport:       '8004'
        publicport:       '8104'
        outboundenabled:  '0'
        protocol:         'http'
        tunnelingenabled: '0'
        max_message_size: '35000000'
        # require:
        #   - Wls_server[wlsServer2]

### wls_server_tlog

it needs wls_setting and when identifier is not provided it will use the 'default', the title must also contain the server name

or use puppet resource wls_server_tlog

For this you need to configure a non transactional datasource

in hiera

    datasource_instances:
        'tlogDS':
          ensure:                      'present'
          drivername:                  'oracle.jdbc.OracleDriver'
          globaltransactionsprotocol:  'None'
          initialcapacity:             '2'
          jndinames:
            - 'jdbc/tlogDS'
          maxcapacity:                 '15'
          target:
            - 'WebServer1'
            - 'JmsWlsServer1'
          targettype:
            - 'Server'
            - 'Server'
          testtablename:               'SQL SELECT 1 FROM DUAL'
          url:                         "jdbc:oracle:thin:@wlsdb.example.com:1521/wlsrepos.example.com"
          user:                        'tlog'
          password:                    'tlog'
          usexa:                       '1'

    server_tlog_instances:
      'JmsWlsServer1':
          ensure:                      'present'
          tlog_enabled:                'true'
          tlog_datasource:             'tlogDS'
          tlog_datasource_prefix:      'TLOG_JmsWlsServer1_'
      'WebServer1':
          ensure:                      'present'
          tlog_enabled:                'true'
          tlog_datasource:             'tlogDS'
          tlog_datasource_prefix:      'TLOG_WebServer1_'


Or as manifest

    wls_server_tlog { 'default/JmsWlsServer1':
      ensure                 => 'present',
      tlog_datasource        => 'tlogDS',
      tlog_datasource_prefix => 'TLOG_JmsWlsServer1_',
      tlog_enabled           => 'true',
    }
    wls_server_tlog { 'default/WebServer1':
      ensure                 => 'present',
      tlog_datasource        => 'tlogDS',
      tlog_datasource_prefix => 'TLOG_WebServer1_',
      tlog_enabled           => 'true',
    }


### wls_cluster

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
      frontendhost            => '10.10.10.10'
      frontendhttpport        => '1001'
      frontendhttpsport       => '1002'
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

### wls_migratable_target

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_migratable_target

    wls_migratable_target { 'wlsServer1 (migratable)':
      ensure                     => 'present',
      cluster                    => 'WebCluster',
      migration_policy           => 'manual',
      number_of_restart_attempts => '6',
      seconds_between_restarts   => '30',
      user_preferred_server      => 'wlsServer1',
    }
    wls_migratable_target { 'wlsServer2 (migratable)':
      ensure                     => 'present',
      cluster                    => 'WebCluster',
      migration_policy           => 'manual',
      number_of_restart_attempts => '6',
      seconds_between_restarts   => '30',
      user_preferred_server      => 'wlsServer2',
    }

    wls_migratable_target { 'Wls11gSetting/wlsServer1 (migratable)':
      ensure                     => 'present',
      cluster                    => 'WebCluster',
      migration_policy           => 'manual',
      number_of_restart_attempts => '6',
      seconds_between_restarts   => '30',
      user_preferred_server      => 'wlsServer1',
    }
    wls_migratable_target { 'Wls11gSetting/wlsServer2 (migratable)':
      ensure                     => 'present',
      cluster                    => 'WebCluster',
      migration_policy           => 'manual',
      number_of_restart_attempts => '6',
      seconds_between_restarts   => '30',
      user_preferred_server      => 'wlsServer2',
    }

or in hiera

    migratable_target_instances:
      'wlsServer1 (migratable)':
          ensure:                     'present'
          cluster:                    'WebCluster'
          migration_policy:           'manual'
          number_of_restart_attempts: '6'
          seconds_between_restarts:   '30'
          user_preferred_server:      'wlsServer1'
          require:
            - Wls_cluster[WebCluster]
      'wlsServer2 (migratable)':
          ensure:                     'present'
          cluster:                    'WebCluster'
          migration_policy:           'manual'
          number_of_restart_attempts: '6'
          seconds_between_restarts:   '30'
          user_preferred_server:      'wlsServer2'
          require:
            - Wls_cluster[WebCluster]

### wls_singleton_service

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_singleton_service

    # this will use default as wls_setting identifier
    wls_singleton_service { 'SingletonService':
        ensure                           => 'present',
        cluster                          => 'ClusterName',
        user_preferred_server            => 'PreferredServerName',
        class_name                       => 'com.example.package.SingletonServiceImpl',
        constrained_candidate_servers    => ['PreferredServerName', 'OtherServerName'],
        additional_migration_attempts    => 2,
        millis_to_sleep_between_attempts => 300000,
        notes                            => 'This is a singleton service that prefers to run on PreferredServerName, but can be migrated to OtherServerName.',
    }

in hiera

    # this will use default as wls_setting identifier
    singleton_service_instances:
      'SingletonService':
        ensure:                            'present'
        cluster:                           'ClusterName'
        user_preferred_server:             'PreferredServerName'
        class_name:                        'com.example.package.SingletonServiceImpl'
        constrained_candidate_servers:
          - 'PreferredServerName'
          - 'OtherServerName'
        additional_migration_attempts:     2
        millis_to_sleep_between_attempts:  300000
        notes:                             'This is a singleton service that prefers to run on PreferredServerName, but can be migrated to OtherServerName.'

### wls_coherence_cluster

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_coherence_cluster

    # this will use default as wls_setting identifier
    wls_coherence_cluster { 'WebCoherenceCluster':
      ensure          => 'present',
      clusteringmode  => 'unicast',
      multicastport   => '33389',
      target          => ['WebCluster'],
      targettype      => ['Cluster'],
      unicastport     => '9999',
      storage_enabled =>  '1',
    }
    wls_coherence_cluster { 'defaultCoherenceCluster':
      ensure         => 'present',
      clusteringmode => 'unicast',
      multicastport  => '33387',
      unicastport    => '8888',
    }

in hiera

    $default_params = {}
    $coherence_cluster_instances = hiera('coherence_cluster_instances', {})
    create_resources('wls_coherence_cluster',$coherence_cluster_instances, $default_params)


    coherence_cluster_instances:
      'clusterCoherence':
        ensure:           'present'
        clusteringmode:   'unicast'
        multicastaddress: '231.1.1.1'
        multicastport:    '33387'
        target:           ['DynamicCluster']
        targettype:       ['Cluster']
        unicastport:      '9099'
        unicastaddress:   '10.10.10.100,10.10.10.200'
        storage_enabled:  '1'

### wls_coherence_server

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_coherence_server

    # this will use default as wls_setting identifier
    wls_coherence_server { 'default':
      ensure         => 'present',
      server         => 'LocalMachine',
      unicastaddress => 'localhost',
      unicastport    => '8888',
    }

### wls_server_template
it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_server_template

    wls_server_template { 'default/ServerTemplateWeb':
      ensure        => 'present',
      arguments     => ['-XX:PermSize=256m','-XX:MaxPermSize=256m'],
      listenport    => '9101',
      sslenabled    => '1',
      ssllistenport => '9102',
    }

in hiera

    $default_params = {}
    $server_template_instances = hiera('server_template_instances', {})
    create_resources('wls_server_template',$server_template_instances, $default_params)


    server_vm_args_permsize:      &server_vm_args_permsize     '-XX:PermSize=256m'
    server_vm_args_max_permsize:  &server_vm_args_max_permsize '-XX:MaxPermSize=256m'
    server_vm_args_memory:        &server_vm_args_memory       '-Xms752m'
    server_vm_args_max_memory:    &server_vm_args_max_memory   '-Xmx752m'


    server_template_instances:
     'ServerTemplateWeb':
      ensure:        'present'
      arguments:
                     - *server_vm_args_permsize
                     - *server_vm_args_max_permsize
                     - *server_vm_args_memory
                     - *server_vm_args_max_memory
      listenport:    '9101'
      sslenabled:    '1'
      ssllistenport: '9102'


### wls_dynamic_cluster
it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_dynamic_cluster

    wls_dynamic_cluster { 'DynamicCluster':
      ensure                 => 'present',
      calculated_listen_port => '0',  # '0' or '1'
      maximum_server_count   => '2',
      nodemanager_match      => 'Node1,Node2',
      server_name_prefix     => 'DynCluster-',
      server_template_name   => 'ServerTemplateWeb',
    }

in hiera

    $default_params = {}
    $dynamic_cluster_instances = hiera('dynamic_cluster_instances', {})
    create_resources('wls_dynamic_cluster',$dynamic_cluster_instances, $default_params)

    dynamic_cluster_instances:
      'DynamicCluster':
        ensure:                 'present'
        calculated_listen_port: '0'        # '0' or '1'
        maximum_server_count:   '2'
        nodemanager_match:      'Node1,Node2'
        server_name_prefix:     'DynCluster-'
        server_template_name:   'ServerTemplateWeb'

### wls_virtual_host

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

### wls_workmanager_constaint

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_workmanager_constaint

    # this will use default as wls_setting identifier
    wls_workmanager_constraint { 'CapacityConstraint':
      ensure          => 'present',
      constrainttype  => 'Capacity',
      constraintvalue => '20',
      target          => ['WebCluster'],
      targettype      => ['Cluster'],
    }
    wls_workmanager_constraint { 'MaxThreadsConstraint':
      ensure          => 'present',
      constrainttype  => 'MaxThreadsConstraint',
      constraintvalue => '5',
      target          => ['WebCluster'],
      targettype      => ['Cluster'],
    }
    wls_workmanager_constraint { 'MinThreadsConstraint':
      ensure          => 'present',
      constrainttype  => 'MinThreadsConstraint',
      constraintvalue => '2',
      target          => ['WebCluster'],
      targettype      => ['Cluster'],
    }
    wls_workmanager_constraint { 'FairShareReqClass':
      ensure          => 'present',
      constrainttype  => 'FairShareRequestClasses',
      constraintvalue => '50',
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
      'FairShareReqClass':
        ensure:          'present'
        constrainttype:  'FairShareRequestClasses'
        constraintvalue: '50'
        target:
          - 'WebCluster'
        targettype:
          - 'Cluster'


### wls_workmanager

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_workmanager

    # this will use default as wls_setting identifier
    wls_workmanager { 'WorkManagerConstraints':
      ensure                => 'present',
      capacity              => 'CapacityConstraint',
      maxthreadsconstraint  => 'MaxThreadsConstraint',
      minthreadsconstraint  => 'MinThreadsConstraint',
      fairsharerequestclass => 'FairShareReqClass',
      stuckthreads          => '0',
      target                => ['WebCluster'],
      targettype            => ['Cluster'],
    }

in hiera

    # this will use default as wls_setting identifier
    workmanager_instances:
      'WorkManagerConstraints':
        ensure:                'present'
        capacity:              'CapacityConstraint'
        maxthreadsconstraint:  'MaxThreadsConstraint'
        minthreadsconstraint:  'MinThreadsConstraint'
        fairsharerequestclass: 'FairShareReqClass'
        stuckthreads:          '1'
        target:
          - 'WebCluster'
        targettype:
          - 'Cluster'


### wls_jdbc_persistence_store
it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_jdbc_persistence_store

    wls_jdbc_persistence_store { 'JDBCStoreX':
      ensure      => 'present',
      datasource  => 'jmsDS',
      prefix_name => 'dev_',
      target      => ['wlsServer1'],
      targettype  => ['Server'],
    }

in hiera

    file_jdbc_store_instances:
      'JDBCStoreX':
          ensure:      'present'
          datasource:  'jmsDS'
          prefix_name: 'dev_'
          target:      ['wlsServer1']
          targettype:  ['Server']

## wls_foreign_jndi_provider 
it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_foreign_jndi_provider 

    wls_foreign_jndi_provider { 'DomainA':
      ensure                  => 'present',
      initial_context_factory => 'weblogic.jndi.WLInitialContextFactory',
      provider_properties     => ['bbb=aaaa', 'xxx=123'],
      provider_url            => 't3://10.10.10.100:7001',
      target                  => ['WebCluster'],
      targettype              => ['Cluster'],
      user                    => 'weblogic',
      password                => 'weblogic1',
    }
    wls_foreign_jndi_provider { 'default/LDAP':
      ensure                  => 'present',
      initial_context_factory => 'com.sun.jndi.ldap.LdapCtxFactory',
      provider_properties     => ['referral=follow'],
      provider_url            => 'ldap://:10.10.10.100:389',
      target                  => ['AdminServer'],
      targettype              => ['Server'],
      user                    => 'cn=orcladmin',
      password                => 'weblogic1',
    }

in hiera


    wls_foreign_jndi_provider_instances:
      'DomainA':
        ensure:                  'present'
        initial_context_factory: 'weblogic.jndi.WLInitialContextFactory'
        provider_properties:     ['bbb=aaaa', 'xxx=123']
        provider_url:            't3://10.10.10.100:7001'
        target:                  ['WebCluster']
        targettype:              ['Cluster']
        user:                    'weblogic'
        password:                'weblogic1'
      'LDAP':
        ensure:                  'present'
        initial_context_factory: 'com.sun.jndi.ldap.LdapCtxFactory'
        provider_properties:     ['referral=follow']
        provider_url:            'ldap://:10.10.10.100:389'
        target:                  ['AdminServer']
        targettype:              ['Server']
        user:                    'cn=orcladmin'
        password:                'weblogic1'


## wls_foreign_jndi_provider _link
it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_foreign_jndi_provider _link

    wls_foreign_jndi_provider_link { 'default/DomainA:aaaa':
      ensure           => 'present',
      local_jndi_name  => 'aaaa',
      remote_jndi_name => 'bbbb',
    }
    wls_foreign_jndi_provider_link { 'default/LDAP:aaaaa':
      ensure           => 'present',
      local_jndi_name  => 'aaaaa',
      remote_jndi_name => 'bbbbb',
    }
    wls_foreign_jndi_provider_link { 'default/LDAP:ccccc':
      ensure           => 'present',
      local_jndi_name  => 'ccccc',
      remote_jndi_name => 'ddddd',
    }

in hiera


    wls_foreign_jndi_provider_link_instances:
      'DomainA:aaaa':
        ensure:                  'present'
        local_jndi_name:         'aaaa'
        remote_jndi_name:        'bbbb'
        require:
          - Wls_foreign_jndi_provider[DomainA]
      'LDAP:aaaaa':
        ensure:                  'present'
        local_jndi_name:         'aaaaa'
        remote_jndi_name:        'bbbbb'
        require:
          - Wls_foreign_jndi_provider[LDAP]
      'LDAP:ccccc':
        ensure:                  'present'
        local_jndi_name:         'ccccc'
        remote_jndi_name:        'ddddd'
        require:
          - Wls_foreign_jndi_provider[LDAP]


### wls_file_persistence_store
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


### wls_safagent

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


### wls_datasource

it needs wls_setting and when identifier is not provided it will use the 'default'.

xaproperties are case sensitive and should be provided as an array containing all values. Use WLST and run ls() in the JDBCXAParams component of your datasource to determine the valid XA properties which can be set. Preserve the order to ensure idempotent behaviour.

or use puppet resource wls_datasource

    # this will use default as wls_setting identifier, no XA properties
    wls_datasource { 'hrDS':
      ensure                           => 'present',
      connectioncreationretryfrequency => '0',
      drivername                       => 'oracle.jdbc.xa.client.OracleXADataSource',
      extraproperties                  => ['SendStreamAsBlob=true', 'oracle.net.CONNECT_TIMEOUT=10001'],
      fanenabled                       => '0',
      globaltransactionsprotocol       => 'TwoPhaseCommit',
      initialcapacity                  => '2',
      initsql                          => 'None',
      jndinames                        => ['jdbc/hrDS', 'jdbc/hrDS2'],
      maxcapacity                      => '15',
      mincapacity                      => '1',
      rowprefetchenabled               => '0',
      rowprefetchsize                  => '48',
      secondstotrustidlepoolconnection => '10',
      statementcachesize               => '10',
      target                           => ['wlsServer1', 'wlsServer2'],
      targettype                       => ['Server', 'Server'],
      testconnectionsonreserve         => '0',
      testfrequency                    => '120',
      testtablename                    => 'SQL SELECT 1 FROM DUAL',
      url                              => 'jdbc:oracle:thin:@dbagent2.alfa.local:1521/test.oracle.com',
      user                             => 'hr',
      usexa                            => '0',
    }
    # This will use XA Properties
    wls_datasource { 'jmsDS':
      ensure                     => 'present',
      drivername                 => 'com.mysql.jdbc.Driver',
      globaltransactionsprotocol => 'None',
      initialcapacity            => '1',
      jndinames                  => ['jmsDS'],
      maxcapacity                => '15',
      mincapacity                => '1',
      statementcachesize         => '10',
      testconnectionsonreserve   => '0',
      target                     => ['WebCluster'],
      targettype                 => ['Cluster'],
      testtablename              => 'SQL SELECT 1',
      url                        => 'jdbc:mysql://10.10.10.10:3306/jms',
      user                       => 'jms',
      password                   => 'pass',
      usexa                      => '1',
      xaproperties               => ['RollbackLocalTxUponConnClose=0', 'RecoverOnlyOnce=0', 'KeepLogicalConnOpenOnRelease=0', 'KeepXaConnTillTxComplete=1', 'XaTransactionTimeout=14400', 'XaRetryIntervalSeconds=60', 'XaRetryDurationSeconds=0', 'ResourceHealthMonitoring=1', 'NewXaConnForCommit=0', 'XaSetTransactionTimeout=1', 'XaEndOnlyOnce=0', 'NeedTxCtxOnClose=0'],
      # To Optionally Configure as Gridlink Datasource
      fanenabled                 => '1',
      onsnodelist                => '10.10.10.110:6200,10.10.10.111:6200',
    }

in hiera


    # this will use default as wls_setting identifier
    datasource_instances:
        'hrDS':
          ensure:                           'present'
          drivername:                       'oracle.jdbc.xa.client.OracleXADataSource'
          extraproperties:
            - 'SendStreamAsBlob=true'
            - 'oracle.net.CONNECT_TIMEOUT=1000'
          globaltransactionsprotocol:  'TwoPhaseCommit'
          initialcapacity:                  '1'
          maxcapacity:                      '15'
          mincapacity:                      '1'
          statementcachesize:               '10'
          jndinames:
           - 'jdbc/hrDS'
          target:
            - 'WebCluster'
            - 'WebCluster2'
          targettype:
            - 'Cluster'
            - 'Cluster'
          testtablename:                    'SQL SELECT 1 FROM DUAL'
          url:                              "jdbc:oracle:thin:@dbagent2.alfa.local:1521/test.oracle.com"
          user:                             'hr'
          password:                         'pass'
          usexa:                            '1'
          xaproperties:
           - 'RollbackLocalTxUponConnClose=0'
           - 'RecoverOnlyOnce=0'
           - 'KeepLogicalConnOpenOnRelease=0'
           - 'KeepXaConnTillTxComplete=1'
           - 'XaTransactionTimeout=14400'
           - 'XaRetryIntervalSeconds=60'
           - 'XaRetryDurationSeconds=0'
           - 'ResourceHealthMonitoring=1'
           - 'NewXaConnForCommit=0'
           - 'XaSetTransactionTimeout=1'
           - 'XaEndOnlyOnce=0'
           - 'NeedTxCtxOnClose=0'
          testconnectionsonreserve:         '0'
          secondstotrustidlepoolconnection: '10'
          testfrequency:                    '120'
          connectioncreationretryfrequency: '0'
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
          password:                    'pass'
          usexa:                       '1'
          # To Optionally Configure as Gridlink Datasource
          fanenabled:                  '1'
          onsnodelist:                 '10.10.10.110:6200,10.10.10.111:6200'

### wls_jmsserver

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_jmsserver

    # this will use default as wls_setting identifier
    wls_jmsserver { 'jmsServer1':
      ensure                      => 'present',
      persistentstore             => 'jmsFile1',
      persistentstoretype         => 'FileStore',
      target                      => ['wlsServer1'],
      targettype                  => ['Server'],
      allows_persistent_downgrade => '0',
      bytes_maximum               => '-1',
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
         ensure:                      'present'
         target:
           - 'wlsServer1'
         targettype:
           - 'Server'
         persistentstore:             'jmsFile1'
         persistentstoretype:         'FileStore'
         allows_persistent_downgrade: '0'
         bytes_maximum:               '-1'
       jmsServer2:
         ensure:              'present'
         target:
           - 'wlsServer2'
         targettype:
           - 'Server'

### wls_jms_module

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

### wls_jms_security_policy

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_jms_security_policy

   # this will use default as wls_setting identifier
   wls_jms_security_policy { 'jmsClusterModule:Topic1:receive':
      ensure           => 'present',
      destinationtype  => 'topic',
      policyexpression => 'Usr(testuser1)',
   }

in hiera

   # this will use default as wls_setting identifier
   jms_security_policy_instances:
      'jmsClusterModule:Topic1:receive':
          ensure:           'present'
          destinationtype:  'topic',
          policyexpression: 'Usr(testuser1)',

### wls_jms_template

it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_jms_template

    wls_jms_template { 'jmsClusterModule:Template-0':
      ensure          => 'present',
      redeliverydelay => '-1',
      redeliverylimit => '-1',
    }

in hiera

    jms_template_instances:
      'jmsClusterModule:Template':
        ensure:          'present'
        redeliverydelay: '-1'
        redeliverylimit: '-1'

### wls_jms_sort_destination_key

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name


    wls_jms_sort_destination_key { 'jmsClusterModule:JMSPriority':
      ensure        => 'present',
      key_type      => 'Int',
      property_name => 'JMSPriority',
      sort_order    => 'Ascending',
    }
    wls_jms_sort_destination_key { 'default/jmsClusterModule:JMSRedelivered':
      ensure        => 'present',
      key_type      => 'Boolean',
      property_name => 'JMSRedelivered',
      sort_order    => 'Ascending',
    }
    wls_jms_sort_destination_key { 'default/jmsClusterModule:JmsMessageId':
      ensure        => 'present',
      key_type      => 'String',
      property_name => 'JmsMessageId',
      sort_order    => 'Descending',
    }

in Hiera

    jms_sort_destination_key_instances:
       'jmsClusterModule:JmsMessageId':
          ensure:        'present'
          key_type:      'String'
          property_name: 'JmsMessageId'
          sort_order:    'Descending'
          require:        Wls_jms_module[jmsClusterModule]
       'jmsClusterModule:JMSPriority':
          ensure:        'present'
          key_type:      'Int'
          property_name: 'JMSPriority'
          sort_order:    'Ascending'
          require:        Wls_jms_module[jmsClusterModule]
       'jmsClusterModule:JMSRedelivered':
          ensure:        'present'
          key_type:      'Boolean'
          property_name: 'JMSRedelivered'
          sort_order:    'Ascending'
          require:        Wls_jms_module[jmsClusterModule]


### wls_connection_factory

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name

or use puppet resource wls_connection_factory

    wls_jms_connection_factory { 'jmsClusterModule:cf':
      ensure                    => 'present',
      attachjmsxuserid          => '0',
      clientidpolicy            => 'Restricted',
      defaulttargeting          => '0',
      jndiname                  => 'jms/cf',
      loadbalancingenabled      => '1',
      messagesmaximum           => '10',
      reconnectpolicy           => 'producer',
      serveraffinityenabled     => '1',
      subdeployment             => 'wlsServers',
      subscriptionsharingpolicy => 'Exclusive',
      transactiontimeout        => '3600',
      xaenabled                 => '0',
    }
    wls_jms_connection_factory { 'default/jmsClusterModule:cf2':
      ensure                    => 'present',
      attachjmsxuserid          => '0',
      clientidpolicy            => 'Restricted',
      defaulttargeting          => '1',
      jndiname                  => 'jms/cf2',
      loadbalancingenabled      => '1',
      messagesmaximum           => '10',
      reconnectpolicy           => 'producer',
      serveraffinityenabled     => '1',
      subscriptionsharingpolicy => 'Exclusive',
      transactiontimeout        => '3600',
      xaenabled                 => '1',
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

### wls_jms_queue

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name

or use puppet resource wls_jms_queue

    wls_jms_queue { 'jmsClusterModule:ErrorQueue':
      ensure            => 'present',
      defaulttargeting  => '0',
      distributed       => '1',
      expirationpolicy  => 'Discard',
      jndiname          => 'jms/ErrorQueue',
      redeliverydelay   => '-1',
      redeliverylimit   => '-1',
      subdeployment     => 'jmsServers',
      timetodeliver     => '-1',
      timetolive        => '-1',
      templatename      => 'Template',
      messagelogging    => '1',
      consumptionpaused => '0',
      insertionpaused   => '0',
      productionpaused  => '0',
    }
    wls_jms_queue { 'jmsClusterModule:Queue1':
      ensure           => 'present',
      defaulttargeting => '0',
      distributed      => '1',
      forwarddelay     => '-1',
      errordestination => 'ErrorQueue',
      expirationpolicy => 'Redirect',
      jndiname         => 'jms/Queue1',
      redeliverydelay  => '2000',
      redeliverylimit  => '3',
      subdeployment    => 'jmsServers',
      timetodeliver    => '-1',
      timetolive       => '300000',
      messagelogging   => '1',
      destination_keys => ['JMSPriority', 'JmsMessageId'],
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
      messagelogging          => '1',
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
         templatename:             'Template'
         messagelogging:           '1'
         insertionpaused:          '0'
         productionpaused:         '0'
         consumptionpaused:        '0'
       'jmsClusterModule:Queue1':
         ensure:                   'present'
         distributed:              '1'
         forwarddelay:             '-1'
         errordestination:         'ErrorQueue'
         expirationpolicy:         'Redirect'
         jndiname:                 'jms/Queue1'
         destination_keys:
            - 'JMSPriority'
            - 'JmsMessageId'
         redeliverydelay:          '2000'
         redeliverylimit:          '3'
         subdeployment:            'jmsServers'
         defaulttargeting:         '0'
         timetodeliver:            '-1'
         timetolive:               '300000'
         messagelogging:           '1'
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
         messagelogging:           '1'


### wls_jms_topic

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name

or use puppet resource wls_jms_topic

    wls_jms_topic { 'jmsClusterModule:Topic1':
      ensure            => 'present',
      balancingpolicy   => 'Round-Robin',
      defaulttargeting  => '0',
      deliverymode      => 'No-Delivery',
      destination_keys  => ['JMSPriority', 'JmsMessageId'],
      distributed       => '1',
      expirationpolicy  => 'Discard',
      forwardingpolicy  => 'Replicated',
      jndiname          => 'jms/Topic1',
      redeliverydelay   => '2000',
      redeliverylimit   => '2',
      subdeployment     => 'jmsServers',
      timetodeliver     => '-1',
      timetolive        => '300000',
      consumptionpaused => '0',
      insertionpaused   => '0',
      productionpaused  => '0',
    }
    wls_jms_topic { 'default/jmsClusterModule:Topic2':
      ensure           => 'present',
      balancingpolicy  => 'Round-Robin',
      defaulttargeting => '0',
      deliverymode     => 'No-Delivery',
      distributed      => '1',
      errordestination => 'ErrorQueue',
      expirationpolicy => 'Redirect',
      forwardingpolicy => 'Replicated',
      jndiname         => 'jms/Topic2',
      redeliverydelay  => '2000',
      redeliverylimit  => '3',
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
         messagelogging:    '0'
         insertionpaused:   '0'
         productionpaused:  '1'
         consumptionpaused: '0'
         destination_keys:
            - 'JMSPriority'
            - 'JmsMessageId'


### wls_jms_quota

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


### wls_jms_subdeployment

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


### wls_saf_remote_context

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



### wls_saf_error_handler

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

### wls_saf_imported_destination

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

### wls_saf_imported_destination_object

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

### wls_foreign_server

it needs wls_setting and when identifier is not provided it will use the 'default', title must also contain the jms module name

or use puppet resource wls_foreign_server

    wls_foreign_server { 'jmsClusterModule:AQForeignServer':
      ensure                => 'present',
      defaulttargeting      => '1',
      extraproperties       => 'datasource=jdbc/hrDS',
      initialcontextfactory => ['oracle.jms.AQjmsInitialContextFactory'],
    }
    wls_foreign_server { 'jmsClusterModule:Jboss':
      ensure                => 'present',
      connectionurl         => 'remote://10.10.10.10:4447',
      defaulttargeting      => '0',
      extraproperties       => ['java.naming.security.principal=jmsuser'],
      initialcontextfactory => 'org.jboss.naming.remote.client.InitialContextFactory',
      subdeployment         => 'wlsServers',
    }

in hiera

    'jmsClusterModule:AQForeignServer':
        ensure:                'present'
        defaulttargeting:      '1'
        extraproperties:
          - 'datasource=jdbc/hrDS'
        initialcontextfactory: 'oracle.jms.AQjmsInitialContextFactory'
    'jmsClusterModule:Jboss':
        ensure:                'present'
        connectionurl:         'remote://10.10.10.10:4447'
        defaulttargeting:      '0'
        extraproperties:
          - 'java.naming.security.principal=jmsuser'
        initialcontextfactory: 'org.jboss.naming.remote.client.InitialContextFactory'
        subdeployment:         'wlsServers'
        password:              'test'


### wls_foreign_server_object

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

### wls_mail_session

it needs wls_setting and when identifier is not provided it will use the 'default'

or use puppet resource wls_mail_server

Valid mail properties are found at: https://javamail.java.net/nonav/docs/api/

    wls_mail_session { 'myMailSession':
      ensure         => 'present',
      jndiname       => 'myMailSession',
      target         => ['ManagedServer1', 'WebCluster'],
      targettype     => ['Server', 'Cluster'],
      mailproperty   => ['mail.host=smtp.hostname.com', 'mail.user=smtpadmin'],
    }


in hiera

    mail_session_instances:
      'myMailSession':
        ensure:  present
        jndiname: 'myMailSession'
        target:
         - 'ManagedServer1'
         - 'WebCluster'
        targettype:
         - 'Server'
         - 'Cluster'
        mailproperty:
         - 'mail.host=smtp.hostname.com'
         - 'mail.user=smtpadmin'

### wls_multi_datasource

it needs wls_setting and when identifier is not provided it will use the 'default'

or use puppet resource wls_multi_datasource

Valid mail properties are found at: https://javamail.java.net/nonav/docs/api/

    wls_multi_datasource { 'myMultiDatasource':
      ensure        => 'present',
      algorithmtype => 'Failover',
      datasources   => ['myJDBCDatasource'],
      jndinames     => ['myMultiDatasource'],
      target         => ['ManagedServer1', 'WebCluster'],
      targettype     => ['Server', 'Cluster'],
      testfrequency => '120',
    }

in hiera

    multi_datasources:
      'myMultiDatasource':
        ensure:        present
        jndinames:     'myMultiDatasource'
        testfrequency: 120
        algorithmtype: 'Failover'
        datasources:
         - 'myJDBCDatasource'
        target:
         - 'ManagedServer1'
         - 'WebCluster'
        targettype:
         - 'Server'
         - 'Cluster'

### wls_jms_bridge_destination

it needs wls_setting and when identifier is not provided it will use the 'default'

or use puppet resource wls_jms_bridge_destination

Valid jms bridge destinations are found at: https://javamail.java.net/nonav/docs/api/

    wls_jms_bridge_destination { 'myBridgeDest':
      ensure                => 'present',
      adapter               => 'eis.jms.WLSConnectionFactoryJNDINoTX',
      classpath             => 'myClasspath',
      connectionfactoryjndi => 'myCFJndi',
      connectionurl         => 'myConnUrl',
      destinationjndi       => 'myDestJndi',
      destinationtype       => 'Queue',
      initialcontextfactory => 'weblogic.jndi.WLInitialContextFactory',
    }

in hiera

    jms_bridge_destinations:
      'myBridgeDest':
        ensure:                  present
        adapter:                'eis.jms.WLSConnectionFactoryJNDINoTX',
        classpath:              'myClasspath',
        connectionfactoryjndi:  'myCFJndi',
        connectionurl:          'myConnUrl',
        destinationjndi:        'myDestJndi',
        destinationtype:        'Queue',
        initialcontextfactory;  'weblogic.jndi.WLInitialContextFactory',

### wls_messaging_bridge

it needs wls_setting and when identifier is not provided it will use the 'default'

or use puppet resource wls_messaging_bridge

Valid messaging bridge properties are found at: https://javamail.java.net/nonav/docs/api/

    wls_messaging_bridge { 'myBrigde':
      ensure                 => 'present',
      asyncenabled           => '1',
      batchinterval          => '-1',
      batchsize              => '10',
      durabilityenabled      => '1',
      idletimemax            => '60',
      qos                    => 'Exactly-once',
      reconnectdelayincrease => '5',
      reconnectdelaymax      => '60',
      reconnectdelaymin      => '15',
      selector               => 'sel',
      transactiontimeout     => '30',
      sourcedestination      => 'mySourceBrigdeDest',
      targetdestination      => 'MyDestBridgeDest',
      target                 => ['ManagedServer1', 'WebCluster'],
      targettype             => ['Server', 'Cluster'],
}


in hiera

    messaging_bridges:
      'myBridge':
        ensure:                 present
        asyncenabled:           '1'
        batchinterval:          '-1',
        batchsize:              '10',
        durabilityenabled:      '1',
        idletimemax:            '60',
        qos:                    'Exactly-once',
        reconnectdelayincrease: '5',
        reconnectdelaymax:      '60',
        reconnectdelaymin::     '15',
        selector:               'sel',
        transactiontimeout:     '30',
        sourcedestination:      'mySourceBrigdeDest',
        targetdestination:      'MyDestBridgeDest',
        target:
         - 'ManagedServer1'
         - 'WebCluster'
        targettype:
         - 'Server'
         - 'Cluster'


### wls_virtual_target

Only for 12.2.1 and higher, it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_virtual_target

    wls_virtual_target { 'default/VT_AdminServer':
      ensure             => 'present',
      channel            => 'PartitionChannel',
      port               => '7011',
      target             => ['AdminServer'],
      targettype         => ['Server'],
      uriprefix          => '/adminserver',
      virtual_host_names => ['10.10.10.10'],
    }
    wls_virtual_target { 'default/VT_CustomerA':
      ensure             => 'present',
      channel            => 'PartitionChannel',
      port               => '8011',
      target             => ['WebCluster'],
      targettype         => ['Cluster'],
      uriprefix          => '/customer_a',
      virtual_host_names => ['10.10.10.100', '10.10.10.200'],
    }
    wls_virtual_target { 'default/VT_CustomerB':
      ensure             => 'present',
      channel            => 'PartitionChannel',
      port               => '8001',
      target             => ['WebCluster'],
      targettype         => ['Cluster'],
      uriprefix          => '/customer_b',
      virtual_host_names => ['10.10.10.100', '10.10.10.200'],
    }
    wls_virtual_target { 'default/VT_Global':
      ensure             => 'present',
      channel            => 'PartitionChannel',
      port               => '8021',
      target             => ['WebCluster'],
      targettype         => ['Cluster'],
      uriprefix          => '/global',
      virtual_host_names => ['10.10.10.100', '10.10.10.200'],
    }

in hiera

    # this will use default as wls_setting identifier
    virtual_target_instances:
      'VT_CustomerA':
        ensure:             'present'
        port:               '8011'
        # portoffset:         '6'
        target:             'WebCluster'
        targettype:         'Cluster'
        uriprefix:          '/customer_a'
        virtual_host_names:
          - '10.10.10.100'
          - '10.10.10.200'
      'VT_CustomerB':
        ensure:             'present'
        channel:            'PartitionChannel'
        port:               '8001'
        target:             'WebCluster'
        targettype:         'Cluster'
        uriprefix:          '/customer_b'
        virtual_host_names:
          - '10.10.10.100'
          - '10.10.10.200'
      'VT_Global':
        ensure:             'present'
        channel:            'PartitionChannel'
        port:               '8021'
        target:             'WebCluster'
        targettype:         'Cluster'
        uriprefix:          '/global'
        virtual_host_names:
          - '10.10.10.100'
          - '10.10.10.200'
      'VT_AdminServer':
        ensure:             'present'
        channel:            'PartitionChannel'
        port:               '7011'
        target:             'AdminServer'
        targettype:         'Server'
        uriprefix:          '/adminserver'
        virtual_host_names:
          - '10.10.10.10'


### wls_resource_group_template

Resource group templates for resource groups or used in a partition resource group.
Only for 12.2.1 and higher, it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_resource_group_template

    wls_resource_group_template { 'default/AppTemplate1':
      ensure => 'present',
    }
    wls_resource_group_template { 'default/AppTemplate2':
      ensure => 'present',
    }

in hiera

    # this will use default as wls_setting identifier
    resource_group_template_instances:
      'AppTemplate1':
        ensure: 'present'
      'AppTemplate2':
        ensure: 'present'

### wls_resource_group

For making global resource groups or for just 1 or more virtual targets, only for 12.2.1 and higher, it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_resource_group

    wls_resource_group { 'default/ResourceGroup':
      ensure => 'present',
    }
    wls_resource_group { 'default/ResourceGroupForAll':
      ensure                  => 'present',
      resource_group_template => 'AppTemplate2',
      virtual_target          => ['VT_AdminServer', 'VT_Global'],
    }

in hiera

    resource_group_instances:
      'ResourceGroup':
        ensure:                   'present'
      'ResourceGroupForAll':
        ensure:                   'present'
        resource_group_template:  'AppTemplate2'
        virtual_target:
          - 'VT_Global'
          - 'VT_AdminServer'

### wls_domain_partition

For making domain partitions or for just 1 or more virtual targets, only for 12.2.1 and higher, it needs wls_setting and when identifier is not provided it will use the 'default'.

You need to restart the AdminServer when somethings changes on the domain partition level, see wls_adminserver type

or use puppet resource wls_domain_partition

    wls_domain_partition { 'default/CustomerA_Partition':
      ensure           => 'present',
      root_file_system => '/opt/oracle/wlsdomains/domains/Wls1221/partitions/CustomerAPartition/system',
      virtual_target   => ['VT_CustomerA'],
    }
    wls_domain_partition { 'default/CustomerB_Partition':
      ensure           => 'present',
      root_file_system => '/opt/oracle/wlsdomains/domains/Wls1221/partitions/CustomerBPartition/system',
      virtual_target   => ['VT_CustomerB'],
    }
    wls_domain_partition { 'default/Global_Partition':
      ensure           => 'present',
      root_file_system => '/opt/oracle/wlsdomains/domains/Wls1221/partitions/GlobalPartition/system',
      virtual_target   => ['VT_AdminServer', 'VT_Global'],
    }

in hiera

    wls_domain_partition_instances:
      'Global_Partition':
        ensure:           'present'
        root_file_system: '/opt/oracle/wlsdomains/domains/Wls1221/partitions/GlobalPartition/system'
        virtual_target:
          - 'VT_AdminServer'
          - 'VT_Global'
      'CustomerA_Partition':
        ensure:           'present'
        root_file_system: '/opt/oracle/wlsdomains/domains/Wls1221/partitions/CustomerAPartition/system'
        virtual_target:
          - 'VT_CustomerA'
      'CustomerB_Partition':
        ensure:           'present'
        root_file_system: '/opt/oracle/wlsdomains/domains/Wls1221/partitions/CustomerBPartition/system'
        virtual_target:
          - 'VT_CustomerB'

### wls_domain_partition_resource_group

For making resource groups inside a domain partition, only for 12.2.1 and higher, it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_domain_partition_resource_group


    wls_domain_partition_resource_group { 'default/CustomerA_Partition:PartitionResourceGroupProducts':
      ensure                  => 'present',
      resource_group_template => 'AppTemplate1',
      virtual_target          => ['VT_CustomerA'],
    }
    wls_domain_partition_resource_group { 'default/CustomerB_Partition:PartitionResourceGroupProducts':
      ensure                  => 'present',
      resource_group_template => 'AppTemplate1',
      virtual_target          => ['VT_CustomerB'],
    }
    wls_domain_partition_resource_group { 'default/Global_Partition:PartitionResourceGroup1':
      ensure         => 'present',
      virtual_target => ['VT_AdminServer', 'VT_Global'],
    }

in hiera

    wls_domain_partition_resource_group_instances:
      'CustomerA_Partition:PartitionResourceGroupProducts':
        ensure:                  'present'
        resource_group_template: 'AppTemplate1'
        virtual_target:
          - 'VT_CustomerA'
      'CustomerB_Partition:PartitionResourceGroupProducts':
        ensure:                  'present'
        resource_group_template: 'AppTemplate1'
        virtual_target:
          - 'VT_CustomerB'
      'Global_Partition:PartitionResourceGroup1':
        ensure:                  'present'
        virtual_target:
          - 'VT_AdminServer'
          - 'VT_Global'

### wls_resource_group_template_deployment

For adding deployments in a resource groups template, only for 12.2.1 and higher, it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_resource_group_template_deployment

    wls_resource_group_template_deployment { 'default/AppTemplate1:jersey-bundle':
      ensure            => 'present',
      deploymenttype    => 'Library',
      versionidentifier => '1.18@1.18.0.0',
    }
    wls_resource_group_template_deployment { 'default/AppTemplate1:webapp':
      ensure         => 'present',
      deploymenttype => 'AppDeployment',
    }

in hiera

    resource_group_template_deployment_instances:
      'AppTemplate1:jersey-bundle':
        ensure:            'present'
        deploymenttype:    'Library'
        versionidentifier: '1.18@1.18.0.0'
        timeout:           120
        remote:            "1"
        upload:            "1"
        localpath:         '/vagrant/jersey-bundle-1.18.war'
      'AppTemplate1:webapp':
        ensure:            'present'
        deploymenttype:    'AppDeployment'
        timeout:           120
        remote:            "1"
        upload:            "1"
        localpath:         '/vagrant/webapp.war'
        require:
           - Wls_resource_group_template_deployment[AppTemplate1:jersey-bundle]


### wls_domain_partition_resource_group_deployment

For adding deployments in a domain partition resource groups, only for 12.2.1 and higher, it needs wls_setting and when identifier is not provided it will use the 'default'.

or use puppet resource wls_domain_partition_resource_group_deployment

    wls_domain_partition_resource_group_deployment { 'CustomerA_Partition:PartitionResourceGroupProducts:jersey-bundle':
      ensure            => 'present',
      deploymenttype    => 'Library',
      versionidentifier => '1.18@1.18.0.0',
    }
    wls_domain_partition_resource_group_deployment { 'CustomerA_Partition:PartitionResourceGroupProducts:webapp':
      ensure         => 'present',
      deploymenttype => 'AppDeployment',
    }
    wls_domain_partition_resource_group_deployment { 'CustomerB_Partition:PartitionResourceGroupProducts:jersey-bundle':
      ensure            => 'present',
      deploymenttype    => 'Library',
      versionidentifier => '1.18@1.18.0.0',
    }
    wls_domain_partition_resource_group_deployment { 'CustomerB_Partition:PartitionResourceGroupProducts:webapp':
      ensure         => 'present',
      deploymenttype => 'AppDeployment',
    }

in hiera

    domain_partition_resource_group_deployment_instances:
      'CustomerA_Partition:PartitionResourceGroupProducts:jersey-bundle':
        ensure:            'present'
        deploymenttype:    'Library'
        versionidentifier: '1.18@1.18.0.0'
        timeout:           120
        remote:            "1"
        upload:            "1"
        localpath:         '/vagrant/jersey-bundle-1.18.war'
      'CustomerA_Partition:PartitionResourceGroupProducts:webapp':
        ensure:            'present'
        deploymenttype:    'AppDeployment'
        timeout:           120
        remote:            "1"
        upload:            "1"
        localpath:         '/vagrant/webapp.war'
        require:
           - Wls_domain_partition_resource_group_deployment[CustomerA_Partition:PartitionResourceGroupProducts:jersey-bundle]

### wls_domain_partition_control

start or stop a domain partition

    'StartCustomerA_Partition':
         ensure:                      'start'
         domain_partition:            'CustomerA_Partition'
         os_user:                     *wls_os_user
         middleware_home_dir:         *wls_middleware_home_dir
         weblogic_user:               *wls_weblogic_user
         weblogic_password:           *domain_wls_password
         adminserver_address:         *domain_adminserver_address
         adminserver_port:            *domain_adminserver_port
         require:
            - Wls_domain_partition[CustomerA_Partition]
    'StartCustomerB_Partition':
         ensure:                      'stop'
         domain_partition:            'CustomerB_Partition'
         os_user:                     *wls_os_user
         middleware_home_dir:         *wls_middleware_home_dir
         weblogic_user:               *wls_weblogic_user
         weblogic_password:           *domain_wls_password
         adminserver_address:         *domain_adminserver_address
         adminserver_port:            *domain_adminserver_port
         require:
            - Wls_domain_partition[CustomerB_Partition]


