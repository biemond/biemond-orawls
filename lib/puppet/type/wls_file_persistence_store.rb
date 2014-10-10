require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  newtype(:wls_file_persistence_store) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a file persistence stores in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_file_persistence_store' }
      wlst template('puppet:///modules/orawls/providers/wls_file_persistence_store/index.py.erb', binding), environment
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

    parameter :domain
    parameter :name
    parameter :file_persistence_name
    parameter :timeout
    property :directory
    property :target
    property :targettype

    add_title_attributes(:file_persistence_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
