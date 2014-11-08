# History

## 1.0.22
- fix for copydomain when the standard domains location is used
- enable storage on wls_coherence_cluster

## 1.0.21
- puppet custom type for 12.1.2, 12.1.3 RCU, checks first if it already exists
- refactor all domains py scripts to standard one with an FMW extension (optional)
- fmw temp directory bug fix

## 1.0.20
- unset DISPLAY on install/configurations actions to avoid X timeout
- exclude the standard puppet attributes from the wls_setting yaml files
- Print the WLST scripts of all the wls types when puppet runs in debug mode
- Added new attributes log_http_filename & log_datasource_filename to the wls_server type
- SOA Cluster 12.1.3 fix for activating soa-infra application
- control the startup delay for the nodemanager with the sleep parameter
- option to assign the jrfcluster to a opss database

## 1.0.19
- changed property and removed propertyvalues of wls_mail_session, now there is no change detected when there is a different sorting
- changed users of wls_group, no change when there is a different sorting
- removed extrapropertiesvalues of wls_datasource, you can use now extraproperties with key=value,key1=value
- removed extrapropertiesvalues of wls_foreign_server, you can use now extraproperties with key=value,key1=value
- New Order parameter on the wls_authentication_provider type so you can change the order
- Timout parameter for all the wls types, can be used to override the default timeout (120s) on every wls resource
- MaxMessageSize parameter for wls_server resource type

## 1.0.18
- small fix for the server_template type with the arguments parameter
- Frontend parameters for wls_cluster
- Option to skip RCU with a domain creation ( weblogic > 12.1.2)
- new WebLogic type wls_mail_session
- new parameter default file store with wls_server

## 1.0.17
- utils.py fix for multiple domains
- Refactor for rubocop warnings

## 1.0.16
- Gridlink support for the Datasource type
- Extra properties can now be removed in a update of the Datasource
- Refactor domain py scripts and use a utils.py script for common functions

## 1.0.15
- RCU 12.1.3 support for MFT
- BSU fix for hard mdw path in patch policy
- OPatch, check the outcome of the action else fail
- SOA Cluster also works for FMW version 11.1.1.6
- wls_server type new attributes two_way_ssl, client_certificate_enforced
- wls_authentication_provider type now works for DefaultIdentityAsserter

## 1.0.14
- Change log Tab for puppetlabs forge

## 1.0.13
- Support for multiple jrf clusters
- New WLS 12c types like wls_server_template, wls_coherence_cluster, wls_dynamic_cluster

## 1.0.12
- SOA 12.1.3 Cluster support
- 12.1.3 FMW fixes
- BSU policy patch
- OAM & OIM cluster support
- 11g option to associate WebTier with a domain

## 1.0.11
- OSB 12.1.3 Cluster support
- FMW domains update for datasources based on servicetable
- Target & targettype on all wls types expects an array
- Same for servers parameter on wls_domain type
- Same for users parameter on wls_group type
- Same virtualhostnames parameter on wls_virtual_host
- Same for jndinames, extraproperties, extrapropertiesvalues parameters on wls_datasource & wls_foreign_server

## 1.0.10
- fixed WebLogic 12.1.2 & 12.1.3 standard domain bug.

## 1.0.9
- WebLogic 12.1.3 (infra) support
- Support for 12.1.3 SOA,OSB,B2B,MFT installation
- 12.1.3 Standard, ADF, SOA, OSB domain (no cluster)
- wls_adminserver type fix when using no custom trust

## 1.0.8
- wls_server pass server arguments as an array, as it makes it easier to use references in YAML
- Added log file options to wls_server

## 1.0.7
- wls_adminserver,wls_managedserver type to start,stop and refresh a managed server ( or subscribe to changes and do an autorestart )
- BSU
- Opatch
- Resource adapter
- Small nodemanager fix

## 1.0.6
- Readme with links
- wls types title cleanup
- Multiple resource adapter entries fix
- wls_domain fix
- bsu & opatch also works on < puppet 3.2
- hiera vars without an undef default

## 1.0.5
- wls_domain type to modify JTA,Security,Log & JPA
- Oracle Unified Directory install, domain, instances creation
- OUD control

## 1.0.4
- wls_deployment type/provider
- Post_classpath param on wls_setting
- WebTier for 12.1.2 and 11.1.1.7
- OIM & OAM 11.1.2.1 & 11.1.2.2 support with OHS OAM Webgate

## 1.0.3
- WLST Domain daemin for fast WLS types execution
- BSU & OPatch absent option and better output when it fails

## 1.0.2
- Custom Identity and Custom Trust

## 1.0.1
- Multi domain support with Puppet WLS types and providers
