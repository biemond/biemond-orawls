require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  #
  Type.newtype(:wls_cluster) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a cluster in an WebLogic domain.'

    ensurable

    set_command(:wlst)
    # set_command(:controller)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_cluster', 'rest_url' => '/management/weblogic/latest/domainConfig/clusters?links=none' }

      wlst template('puppet:///modules/orawls/providers/wls_cluster/index.py.erb', binding), environment
      # result = controller template('puppet:///modules/orawls/providers/wls_cluster/index.py.erb', binding), environment

      # result.each do |item|
      #   item['clusteraddress'] = item.delete 'clusterAddress' unless item.has_key?('clusteraddress')

      #   if item['servers'].kind_of?(Array)
      #     servers_array = Array.new
      #     item['servers'].each do |server|
      #       servers_array.push server['identity'][1]
      #     end
      #     item.delete 'servers'
      #     item['servers'] = servers_array.join(',')
      #   end

      #   item['messagingmode'] = item.delete 'clusterMessagingMode' unless item.has_key?('messagingmode')
      #   item['multicastaddress'] = item.delete 'multicastAddress' unless item.has_key?('multicastaddress')
      #   item['unicastbroadcastchannel'] = item.delete 'clusterBroadcastChannel' unless item.has_key?('unicastbroadcastchannel')
      #   item['multicastport'] = item.delete 'multicastPort' unless item.has_key?('multicastport')

      #   item['frontendhost'] = item.delete 'frontendHost' unless item.has_key?('frontendhost')

      #   if item.has_key?('frontendHTTPPort')
      #     value = item['frontendHTTPPort']
      #     item.delete 'frontendHTTPPort'
      #     item['frontendhttpport'] = value == 0 ? nil : value
      #   end

      #   if item.has_key?('frontendHTTPSPort')
      #     value = item['frontendHTTPSPort']
      #     item.delete 'frontendHTTPSPort'
      #     item['frontendhttpsport'] = value == 0 ? nil : value
      #   end

      #   item['migrationbasis'] = item.delete 'migrationBasis' unless item.has_key?('migrationbasis')
      #   item['migration_table_name'] = item.delete 'autoMigrationTableName' unless item.has_key?('migration_table_name')
      #   item['migration_datasource'] = item.delete 'dataSourceForAutomaticMigration' unless item.has_key?('migration_datasource')
      #   item['securereplication'] = item.delete 'secureReplicationEnabled' unless item.has_key?('securereplication')
      #   item['datasourceforjobscheduler'] = item.delete 'dataSourceForJobScheduler' unless item.has_key?('datasourceforjobscheduler')

      # end
      # result
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      environment = { 'action' => 'create', 'type' => 'wls_cluster'}
      # all_actions = Array.new
      # cluster_create = Hash.new
      # cluster_create['name'] = cluster_name
      # cluster_create['domain'] = domain

      # all_actions.push cluster_create

      # cluster_create_1 = Hash.new
      # cluster_create_1['rest_url'] = '/management/weblogic/latest/edit/clusters'
      # cluster_create_1_attributes = Hash.new
      # cluster_create_1_attributes['name'] = cluster_name
      # cluster_create_1_attributes['clusterAddress'] = clusteraddress unless clusteraddress == nil
      # cluster_create_1_attributes['clusterMessagingMode'] = messagingmode unless messagingmode == nil
      # cluster_create_1_attributes['multicastAddress'] = multicastaddress unless multicastaddress == nil
      # cluster_create_1_attributes['clusterBroadcastChannel'] = unicastbroadcastchannel unless unicastbroadcastchannel == nil
      # cluster_create_1_attributes['multicastPort'] = multicastport unless multicastport == nil

      # cluster_create_1_attributes['frontendHost'] = frontendhost unless frontendhost == nil
      # cluster_create_1_attributes['frontendHTTPPort'] = frontendhttpport unless frontendhttpport == nil
      # cluster_create_1_attributes['frontendHTTPSPort'] = frontendhttpsport unless frontendhttpsport == nil

      # cluster_create_1_attributes['migrationBasis'] = migrationbasis unless migrationbasis == nil
      # cluster_create_1_attributes['autoMigrationTableName'] = migration_table_name unless migration_table_name == nil
      # cluster_create_1_attributes['dataSourceForAutomaticMigration'] = migration_datasource unless migration_datasource == nil
      # cluster_create_1_attributes['secureReplicationEnabled'] = securereplication unless securereplication == nil
      # cluster_create_1_attributes['dataSourceForJobScheduler'] = datasourceforjobscheduler unless datasourceforjobscheduler == nil

      # cluster_create_1['attributes'] = cluster_create_1_attributes

      # all_actions.push cluster_create_1

      # environment['attributes'] = all_actions
      # controller template('puppet:///modules/orawls/providers/wls_cluster/create.py.erb', binding), environment
      template('puppet:///modules/orawls/providers/wls_cluster/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "

      environment = { 'action' => 'modify', 'type' => 'wls_cluster'}
      # all_actions = Array.new
      # cluster_modify = Hash.new
      # cluster_modify['name'] = cluster_name
      # cluster_modify['domain'] = domain

      # all_actions.push cluster_modify

      # cluster_modify_1 = Hash.new
      # cluster_modify_1['rest_url'] = "/management/weblogic/latest/edit/clusters/#{cluster_name}"
      # cluster_modify_1_attributes = Hash.new

      # cluster_modify_1_attributes['clusterAddress'] = clusteraddress unless clusteraddress == nil
      # cluster_modify_1_attributes['clusterMessagingMode'] = messagingmode unless messagingmode == nil
      # cluster_modify_1_attributes['multicastAddress'] = multicastaddress unless multicastaddress == nil
      # cluster_modify_1_attributes['clusterBroadcastChannel'] = unicastbroadcastchannel unless unicastbroadcastchannel == nil
      # cluster_modify_1_attributes['multicastPort'] = multicastport unless multicastport == nil

      # cluster_modify_1_attributes['frontendHost'] = frontendhost unless frontendhost == nil
      # cluster_modify_1_attributes['frontendHTTPPort'] = frontendhttpport unless frontendhttpport == nil
      # cluster_modify_1_attributes['frontendHTTPSPort'] = frontendhttpsport unless frontendhttpsport == nil

      # cluster_modify_1_attributes['migrationBasis'] = migrationbasis unless migrationbasis == nil
      # cluster_modify_1_attributes['autoMigrationTableName'] = migration_table_name unless migration_table_name == nil
      # cluster_modify_1_attributes['dataSourceForAutomaticMigration'] = migration_datasource unless migration_datasource == nil
      # cluster_modify_1_attributes['secureReplicationEnabled'] = securereplication unless securereplication == nil
      # cluster_modify_1_attributes['dataSourceForJobScheduler'] = datasourceforjobscheduler unless datasourceforjobscheduler == nil

      # cluster_modify_1['attributes'] = cluster_modify_1_attributes

      # all_actions.push cluster_modify_1

      # environment['attributes'] = all_actions

      # controller template('puppet:///modules/orawls/providers/wls_cluster/modify.py.erb', binding), environment
      template('puppet:///modules/orawls/providers/wls_cluster/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "

      environment = { 'action' => 'destroy', 'type' => 'wls_cluster'}
      # all_actions = Array.new
      # cluster_create = Hash.new
      # cluster_create['name'] = cluster_name
      # cluster_create['domain'] = domain

      # all_actions.push cluster_create

      # cluster_destroy_1 = Hash.new
      # cluster_destroy_1['rest_url'] = "/management/weblogic/latest/edit/clusters/#{cluster_name}"
      # cluster_destroy_1['attributes'] = Hash.new

      # all_actions.push cluster_destroy_1

      # environment['attributes'] = all_actions

      # controller template('puppet:///modules/orawls/providers/wls_cluster/destroy.py.erb', binding), environment
      template('puppet:///modules/orawls/providers/wls_cluster/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :cluster_name
    parameter :timeout
    property :servers
    property :clusteraddress
    property :migrationbasis
    property :migration_datasource
    property :migration_table_name
    property :messagingmode
    property :datasourceforjobscheduler
    property :unicastbroadcastchannel
    property :multicastaddress
    property :multicastport
    property :frontendhost
    property :frontendhttpport
    property :frontendhttpsport
    property :securereplication

    add_title_attributes(:cluster_name) do
      /^((.*\/)?(.*)?)$/
    end

    #
    # Manage auto requires
    #
    autorequire(:wls_datasource)  {
      ["#{domain}/#{migration_datasource}",
       "#{domain}/#{datasourceforjobscheduler}"]
    }

  end
end
