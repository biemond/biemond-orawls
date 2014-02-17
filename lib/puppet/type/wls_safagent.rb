require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_safagent) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a cluster in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      wlst template('providers/wls_safagent/index.py', binding)
    end

    on_create do
      Puppet.info "create #{name} "
      template('providers/wls_safagent/create.py', binding)
    end

    on_modify do
      Puppet.info "modify #{name} "
      template('providers/wls_safagent/modify.py', binding)
    end

    on_destroy do
      Puppet.info "destroy #{name} "
      template('providers/wls_safagent/destroy.py', binding)
    end

    parameter :name
    property  :servicetype
    property  :persistentstore
    property  :persistentstoretype
    property  :target
    property  :targettype


  private 

    def name
      self[:name]
    end

    def servicetype
      self[:servicetype]
    end

    def persistentstore
      self[:persistentstore]
    end

    def persistentstoretype
      self[:persistentstoretype]
    end

    def target
      self[:target]
    end

    def targettype
      self[:targettype]
    end

  end
end
