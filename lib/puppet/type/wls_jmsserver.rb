require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jmsserver) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a jmsserver in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      wlst template('puppet:///modules/orawls/providers/wls_jmsserver/index.py.erb', binding)
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jmsserver/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jmsserver/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jmsserver/destroy.py.erb', binding)
    end

    parameter :name
    property  :persistentstore
    property  :persistentstoretype
    property  :target
    property  :targettype


  private 

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
