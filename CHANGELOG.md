# History

## 2.0.7
- wls_setting has tmp_path parameter for the wls types index output, wls types index output is now uinque for every value/domain of wls_setting
- get_attribute_value for index files of the wls types to handle all data types on the right way, located in common.py.erb

## 2.0.6
- fix nil or '' values on onprovider_specific of wls_authentication_provider
- be able to set orainstpath_dir parameter on weblogic, weblogic_type and fmw

## 2.0.5
- Fix ohs domain for 12.1.3 webtier
- Added FMW cleanup on the extract directory and on the FMW files when remote file = true

## 2.0.4
- Allow forward slash in the wls type title name, old title regex for detecting the wls_setting name was too eager but the use of slash in the wls_setting name is now not allowed anymore.

## 2.0.3
- added oim_configured function check to oimconfig.pp

## 2.0.2
- copydomain uses new domain function fixed the issue introduced with 2.0.1

## 2.0.1
- Puppet 4 ruby functions
- Generated Puppet documentation inside the doc folder

## 2.0.0
- Puppet 4 new features, removed support for Puppet 3, please use latest version 1.X of oradb

## 1.0.58
- Option to ignore the defaultCoherenceCluster on a domain
- restrictive permissions for orainst & nodemanager.properties
- FMW webcenter sites support
- allow multiple remote middleware installations on the same host

## 1.0.57
- Added support for Wls/FMW 12.2.1.2
- Changing indentation from "2" to "4" in wls_exec statements

## 1.0.56
- new type wls_ohsserver to control the ohs standalone server or subscribe to changes
- orawls::ohs::forwarder type, re-factored and improved version of orawls::ohs::config
- ohs standalone domain fix for startComponent ( > 12.1.2, adding machine to the domain)
- Apply same BSU patch on different middleware homes
- added weblogic install parameters force & validation

## 1.0.55
- Option for Control.pp and wls_managedserver to use secure connection to the adminserver
- For an OSB domain without a DB ( owsm_enabled = false ) enables now the Derby database so wlsbjmsrpDataSource is active and osb servers comes up in running mode

## 1.0.54
- SOA 12.2.1.1 bam fix for single node clusters
- wls_managedserver fix for forced shutdown/restart
- domain fix for nodemanager properties & domain extension template

## 1.0.53
- nodemanager manifest will auto restart nodemanager when a property is changed
- copydomain now support t3s with custom trust
- wls_setting, wls_adminserver, control, copydomain, nodemanager have new attribute extra_arguments which allows you to pass on some arguments to the component
- reduce info log output -> moved to debug
- more functionality to run orawls with a non-root user like rcu & opatch

## 1.0.52
- fix wls type weblogicConnectUrL bug when running in debug mode

## 1.0.51
- Tested against WebLogic 12.2.1.1 + INFRA, SOA, OSB, OHS, use 12.2.1.1 as version
- add JSSE to wls_daemon when trust is used, this way t3s also works on wls 10.3
- functionality to run orawls with a non-root user, see [this PR](https://github.com/biemond/biemond-orawls/pull/343)

## 1.0.50
- weblogic_type define which support multiple middleware homes on same vm
- fmwcluster supports now not secure nodemanagers for wls server control
- fmw install fix for other fmw products than osh
- osb 12.1.3 cluster adapter target fix
- jrf domain template fix
- common template fix when an wls attribute is nil

## 1.0.49
- Support for standalone webtier 12.1.2, 12.1.3 & 12.2.1
- changed wls_managedserver type code so it used WLST to test if it is active plus force it to running
- OIM/OAM 11.1.2.3 cluster fixes
- FMW install fixes when it has more than 3 input files
- Unpack, new parameter $server_start_mode on copydomain with value test or prod
- wls_domain, new attribute log_domain_log_broadcast_severity
- wls_server, new attributes log_stdout_severity, log_log_file_severity

## 1.0.48
- opatch manifest also works for removing patches
- wls types fix for 12.2.1 and which got passwords attributes
- wls_resource_group_template new MT type but only for WebLogic 12.2.1
- wls_resource_group new MT type but only for WebLogic 12.2.1
- wls_domain_partition new MT type but only for WebLogic 12.2.1
- wls_domain_partition_resource_group new MT type but only for WebLogic 12.2.1
- wls_resource_group_template_deployment new MT type but only for WebLogic 12.2.1
- wls_domain_partition_resource_group_deployment new MT type but only for WebLogic 12.2.1
- wls_domain_partition_control new MT type but only for WebLogic 12.2.1
- wls_setting new attribute use_default_value_when_empty, when you want to make sure the wls type properties will set its default mbean values when it is not provided by your puppet configuration.

## 1.0.47
- heavy WLST refactoring for all the wls types, less and more simple code, auto detect the right type, better fault handling
- wls_jms_security_policy new type
- wls_virtual_target new type but only for WebLogic 12.2.1
- option to override the default machine in the domain manifest
- MQ resource adapter mininal template
- OSB domain template fix
- wls_datasource, new attributes remove_infected_connections ,connectionreservetimeoutseconds and inactiveconnectiontimeoutseconds

## 1.0.46
- added support for 12.2.1 fast rest management interface, requires 12.2.1 or higher & only works for now on wls_cluster (lib/puppet/type/wls_server.rb plus wls_setting must contain a http connect url)
- added MQ adapter for resourceadapter
- soaqs (SOA Quickstart) 12.1.3 & 12.2.1 install on FMW
- urandom/rng support for RedHat 5 family
- add support for provider_specific attributes on wls_authentication_provider
- be able to change the password on wls_datasource
- fix for wls_clusters without servers
- new log_date_pattern attribute for wls_server, wls_domain
- fmwcluster manifest with trust parameters

## 1.0.45
- wls_migratable_target fixes with constrained_candidate_servers
- resource adapters option to escape values
- wls_server fix when no arguments is provided
- Nodemanager fails to start first time if param log_dir is used and directory doesn't exist
- security/permissions fixes with files which can contain passwords
- Fix easy_type load issues in specific situation (puppet master)
- added JAVA_HOME to (un)pack
- wls_group allow additions & removal of users in group
- wls_datasource new attribute wrapdatatypes
- wls_role new type
- wls_rcu show now the error output when it fails
- wls_jms_queue, wls_jms_topic new attributes insertionpaused, consumptionpaused, productionpaused
- wls_domain, new attribute exalogicoptimizationsenabled

## 1.0.44
- WebLogic 12.2.1 standard and infrastructure edition installation
- FMW 12.2.1 SOA Suite, OSB, Webtier (OHS), Forms, B2B, WC, WCC ( Webcenter portal, Webcenter content) installation
- 12.2.1 domains for standard, soa, osb, bam, adf, adf_restricted which is new in 12.2.1 and requires no RCU/DB
- 12.2.1 fmwcluster support for Service Bus (OSB), SOA Suite (BPM, ESS, BAM)
- wls_jms_topic distributed fix plus new attribute ForwardingPolicy
- wls_server modify fix for arguments, classpath etc. plus multiple arguments as an array are converted to a space as separator instead of newline
- new type wls_jms_sort_destination_key  and added this parameter to wls_queue + wls_topic
- new type wls_foreign_jndi_provider  + links
- domain.pp allows you to set a separate domain password, nodemanager_username + password on a domain

## 1.0.43
- Allow multiple fmw installations of the same product on a middleware home
- optimized wls_opatch type/provider which will replace the opatch type
- opatch type/provider fix for if the patch is already installed
- be able to set all the possible Nodemanager properties
- save all the WLST scripts of all the wls types to a temporary directory with wls_setting

## 1.0.42
- Allow opatch to apply the same patch multiple times on the same node
- new wls_server_tlog resource for adding transaction logs to a database
- file resource adapter fix
- fix permissions on wls_settings file
- sanitised title in the fmw manifest
- wls types empty attributes fix

## 1.0.41
- fixed wls_group absent without user attribute bug
- empty target fix on the wls types
- statementcachesize bug with wls_datasource
- wls_queue, wls_topic new attribute deliverymode
- subdeployment and defaulttargeting checks for the jms wls types
- new type wls_migratable_target

## 1.0.40
- BAM only domain option
- Wls_server new attributes sslHostnameVerifier, useServerCerts
- Added FileAdapter to resource adapter
- Cleanup Puppet type interfaces

## 1.0.39
- Works & Tested on puppet 4.2.1
- Oracle Forms & Reports 11.1.1.7 or 11.1.2 support
- Wls_server new attributes frontendhost, frontendhttpport and frontendhttpsport

## 1.0.38
- wls_server new attributes auto_restart & autokillwfail for automatic restart when the server crashes, or automatically kill when the server hangs
- wls_jms_queue, wls_jms_topic new attribute messagelogging
- wls_domain new attributes setinternalappdeploymentondemandenable, setconfigbackupenabled, setarchiveconfigurationcount, setconfigurationaudittype
- Dynamictargetting for wls_cluster, wls_datasource, wls_mail_session
- wls_datasource new attribute shrinkfrequencyseconds

## 1.0.37
- xa properties fix for wls_datasource
- custom weblogic home directory for WebLogic 10.3 and BSU patch
- target attribute used in wls types are now idempotent

## 1.0.36
- support for FMW installation which has 3 install files like oim/oam 11.1.2.3
- Webtier configuration for OAM
- wls_server_channel added keystore attributes
- wls_jms_queue ForwardDelay bug plus new attribute templatename
- wls_datasource new attributes row prefetch and initsql
- wls_workmanager new attribute fairshare
- wls_coherence_template new attribute classpath
- wls_deployment bug when version is none

## 1.0.35
- custom wls resource types now also supports t3s with customtrust done by wls_settings
- adminserver_ssl_port parameter on the domain.pp manifest
- wls_settings don't show the password in the output
- new resource type wls_jdbc_persistence_store
- new resource type wls_jms_template
- wls_deployment planpath fixes
- wls_datasource fixes
- removed default value -1 on forward delay on wls_jms_queue
- wls_server, new attribute listenportenabled
- wls_jms_connection_factory, xa fix plus new attributes localjndiname, defaultdeliverymode, defaultredeliverydelay
- wls_workmanager_constraint, Add the ability to manage fairshare class.

## 1.0.34
- Copydomain FMW apps_dir fix
- FTP Resource adapter plus resource adapter fixes
- New type wls_coherence_server
- Moved 12c nodemanager properties from domain.pp to nodemanager.pp so custom trust will also work
- Added urandom fixes and use notify when there is rngd configuration refresh

## 1.0.33
- added ESS (enterprise schedular) to OSB domain + FMW cluster option
- RCU prefix compare check fix ( Uppercase )
- SOA FMW cluster fixes for latest 12.1.3 soa patch
- SOA FMW cluster fix for soa with bam
- Java tmp dir option for 12c FMW software install
- wls_server, new attribute WeblogicPluginEnabled
- Optional DefaultUserNameMapperAttributeType fix in wls_identity_asserter
- Added bash shell to su -c commands like opatch, bsu, wls_adminserver, rcu types

## 1.0.32
- new wls_singleton_service type
- wls_jms_bridge_destination fix for username and password
- fiddyspence/sleep fix so it works with hiera and string value as input
- added log file to tmp dir + level for the weblogic 10.3 or 11g installation output
- Multiple targets for wls_jms_module type
- new wls_deployment attributes for stagingmode, remote and upload
- able to provide the sys username for the FMW domain RCU action
- derby flag on false in setDomainEnv when it is an OSB or SOA domain

## 1.0.31
- wls_jms_queue, new attribute forwarddelay
- wls_foreign_server_object, bug when removing object plus also removing dependencies
- wls_cluster, new attribute clusteraddress
- nodemanager.properties was overwritten in case of weblogic 12c and a domain extension
- nodemanager with 12c didn't start when log_dir was empty

## 1.0.30
- download dir dependency cycle error between weblogic and domain manifest.
- bsu unzip -o option instead of -n so the new readme is also added to the cache_dir
- wls_server, new attributes log_redirect_stderr_to_server, log_redirect_stdout_to_server, restart_max, log_http_file_count, log_http_number_of_files_limited, bea_home
- wls_jmsserver, new attributes bytes_maximum, allows_persistent_downgrade
- wls_datasource, new attributes secondstotrustidlepoolconnection, testfrequency, connectioncreationretryfrequency
- wls_server_channnel, new attributes publicport, max_message_size

## 1.0.29
- calculated_listen_port attribute for wls_dynamic_cluster
- mincapacity, statementcachesize, testconnectionsonreserve for wls_datasource
- wls_managedserver type fix when target is cluster, doesn't use ps -ef but uses wlst to check the cluster status
- new wls_messaging_bridge wls type
- new wls_jms_bridge_destination wls type
- wls_setting added a 'default' entry in wls_settings.yaml even when default is not used

## 1.0.28
- new wls_identity_asserter type for customising default identy asserter
- xaproperties attributes in wls_datasource
- better error handling for wls_authentication_provider ordering
- option to skip the OPSS security store migration from file to the database in fmwcluster.pp
- Custom type for oracle weblogic/domain directory structure instead of using a structure manifest
- logintimeout attribute for wls_server
- added some extra autorequire on wls resource types

## 1.0.27
- bug fixes in auto require and post classpath parameter bug when running in debug mode
- wls_multi_datasource resource type added

## 1.0.26
- auto require based on the wls resource parameters, no need to use require on the all wls resource types
- wls_adminserver type used plain as a default in nmconnect

## 1.0.25
- Auto require on wls resource types
- urandom fix for rngd service on RedHat Family version 7
- Secure replication parameter for wls_cluster
- ignore ldap providers for wls_user & wls_group
- Support for nodemanagers without security ( plain, with nodemanager_secure_listener = false) on control.pp, nodemanager.pp & domain.pp

## 1.0.24
- Wls_setting resource type check for required attributes
- Timeout parameter bug on all wls resource types ( the default 120 was always used)
- Nodemanager.pp exec sleep command replaced by fiddyspence/sleep resource type, will check every 2 seconds with netstat

## 1.0.23
- Solaris 11 fixes for nodemanager, wls_adminserver & wls_managedserver resource types
- wls_server resource type changes like: check for Adminserver creation/deletion, new properties tunnelingenabled, log_http_format_type, log_http_format, default_file_store, log_datasource_filename
- wls_domain resource type properties: platform-m-bean-server-enabled, platform-m-bean-server-used, show-archived-real-path-enabled
- wls_jms_connection_factory resource type properties: client-id-policy, subscription-sharing-policy, messages-maximum, reconnect-policy, load-balancing-enabled, server-affinity-enabled, attach-jmsx-user-id
- changed oraInst.loc permissions to 0755

## 1.0.22
- fix for copydomain when the standard domains location is used
- enable storage on wls_coherence_cluster
- AdminServer option to listen on all interfaces, adminserver_listen_on_all_interfaces = true on domain.pp

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
