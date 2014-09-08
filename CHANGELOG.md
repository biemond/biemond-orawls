#History

##1.0.15
- RCU support for MFT 

##1.0.14
- Change log Tab for puppetlabs forge

##1.0.13 
- Support for multiple jrf clusters
- New WLS 12c types like wls_server_template, wls_coherence_cluster, wls_dynamic_cluster

##1.0.12
- SOA 12.1.3 Cluster support
- 12.1.3 FMW fixes
- BSU policy patch
- OAM & OIM cluster support
- 11g option to associate WebTier with a domain

##1.0.11
- OSB 12.1.3 Cluster support
- FMW domains update for datasources based on servicetable
- Target & targettype on all wls types expects an array
- Same for servers parameter on wls_domain type
- Same for users parameter on wls_group type
- Same virtualhostnames parameter on wls_virtual_host
- Same for jndinames, extraproperties, extrapropertiesvalues parameters on wls_datasource & wls_foreign_server 

##1.0.10 
- fixed WebLogic 12.1.2 & 12.1.3 standard domain bug.

##1.0.9 
- WebLogic 12.1.3 (infra) support
- Support for 12.1.3 SOA,OSB,B2B,MFT installation
- 12.1.3 Standard, ADF, SOA, OSB domain (no cluster) 
- wls_adminserver type fix when using no custom trust

##1.0.8 
- wls_server pass server arguments as an array, as it makes it easier to use references in YAML
- Added log file options to wls_server 

##1.0.7
- wls_adminserver,wls_managedserver type to start,stop and refresh a managed server ( or subscribe to changes and do an autorestart )
- BSU
- Opatch
- Resource adapter
- Small nodemanager fix 

##1.0.6
- Readme with links
- wls types title cleanup
- Multiple resource adapter entries fix
- wls_domain fix
- bsu & opatch also works on < puppet 3.2
- hiera vars without an undef default

##1.0.5
- wls_domain type to modify JTA,Security,Log & JPA 
- Oracle Unified Directory install, domain, instances creation
- OUD control

##1.0.4 
- wls_deployment type/provider
- Post_classpath param on wls_setting
- WebTier for 12.1.2 and 11.1.1.7
- OIM & OAM 11.1.2.1 & 11.1.2.2 support with OHS OAM Webgate

#1.0.3 
- WLST Domain daemin for fast WLS types execution
- BSU & OPatch absent option and better output when it fails

#1.0.2
- Custom Identity and Custom Trust

#1.0.1
- Multi domain support with Puppet WLS types and providers
