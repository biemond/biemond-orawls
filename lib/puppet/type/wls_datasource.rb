require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_datasource) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a datasource in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      wlst template('puppet:///modules/orawls/providers/wls_datasource/index.py.erb', binding)
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

    parameter :name
    parameter :password
    property  :target
    property  :targettype
    property  :jndinames
    property  :drivername
    property  :url
    property  :usexa
    property  :user
    property  :testtablename
    property  :globaltransactionsprotocol
    property  :extraproperties
    property  :extrapropertiesvalues
    property  :maxcapacity
    property  :initialcapacity
  end
end
