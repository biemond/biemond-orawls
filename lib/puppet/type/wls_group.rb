require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_group) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage group in an WebLogic Secuirty Realm."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      wlst template('puppet:///modules/orawls/providers/wls_group/index.py.erb', binding)
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_group/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_group/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_group/destroy.py.erb', binding)
    end

    parameter :name
    property  :realm
    property  :authenticationprovider
    property  :users
    property  :description
  end
end
