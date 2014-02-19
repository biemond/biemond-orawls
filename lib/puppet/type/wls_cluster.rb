require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_cluster) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a cluster in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      wlst template('providers/wls_cluster/index.py', binding)
    end

    on_create do
      Puppet.info "create #{name} "
      template('providers/wls_cluster/create.py', binding)
    end

    on_modify do
      Puppet.info "modify #{name} "
      template('providers/wls_cluster/modify.py', binding)
    end

    on_destroy do
      Puppet.info "destroy #{name} "
      template('providers/wls_cluster/destroy.py', binding)
    end

    parameter :name
    property  :servers
    property  :migrationbasis
    property  :messagingmode

  private 


    def servers
      self[:servers]
    end

    def migrationbasis
      self[:migrationbasis]
    end

    def messagingmode
      self[:messagingmode]
    end


  end
end
