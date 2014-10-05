require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  newtype(:wls_mail_session) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a mail_session in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_mail_session' }
      wlst template('puppet:///modules/orawls/providers/wls_mail_session/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_mail_session/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_mail_session/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_mail_session/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :mailsession_name

    # Shared
    property :target
    property :targettype
    property :jndiname

    property :mailproperty

    add_title_attributes(:mailsession_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
