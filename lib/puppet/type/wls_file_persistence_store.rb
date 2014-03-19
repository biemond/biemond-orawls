require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_file_persistence_store) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a file persistence stores in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      wlst template('puppet:///modules/orawls/providers/wls_file_persistence_store/index.py.erb', binding)
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_file_persistence_store/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_file_persistence_store/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_file_persistence_store/destroy.py.erb', binding)
    end

    parameter :name
    property  :directory
    property  :target
    property  :targettype

  private 

    def directory
      self[:directory]
    end

    def target
      self[:target]
    end

    def targettype
      self[:targettype]
    end

  end
end
