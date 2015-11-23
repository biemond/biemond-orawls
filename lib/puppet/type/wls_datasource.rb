require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_datasource) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a datasource in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_datasource' }
      wlst template('puppet:///modules/orawls/providers/wls_datasource/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_datasource/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_datasource/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_datasource/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :datasource_name
    parameter :password
    parameter :timeout

    property :target
    property :targettype
    property :jndinames
    property :drivername
    property :url
    property :usexa
    property :user
    property :testtablename
    property :globaltransactionsprotocol
    property :extraproperties
    property :xaproperties
    property :maxcapacity
    property :initialcapacity
    property :fanenabled
    property :onsnodelist
    property :mincapacity
    property :statementcachesize
    property :testconnectionsonreserve
    property :secondstotrustidlepoolconnection
    property :testfrequency
    property :connectioncreationretryfrequency
    property :rowprefetchenabled
    property :rowprefetchsize
    property :initsql
    property :shrinkfrequencyseconds
    property :wrapdatatypes

    add_title_attributes(:datasource_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
