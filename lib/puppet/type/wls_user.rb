require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_user) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage user in an WebLogic Secuirty Realm."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      wlst template('puppet:///modules/orawls/providers/wls_user/index.py.erb', binding)
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_user/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_user/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_user/destroy.py.erb', binding)
    end

    parameter :name
    parameter :password
    property  :realm
    property  :authenticationprovider
    property  :description

  private 

    def description
      self[:description]
    end

    def password
      self[:password]
    end

    def realm
      self[:realm]
    end

    def authenticationprovider
      self[:authenticationprovider]
    end

  end
end
