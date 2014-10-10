require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  newtype(:wls_authentication_provider) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage authentication providers in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_authentication_provider' }
      wlst template('puppet:///modules/orawls/providers/wls_authentication_provider/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_authentication_provider/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_authentication_provider/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_authentication_provider/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :authentication_provider_name

    property :control_flag
    parameter :providerclassname
    parameter :attributes
    parameter :attributesvalues
    parameter :order

    add_title_attributes(:authentication_provider_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
