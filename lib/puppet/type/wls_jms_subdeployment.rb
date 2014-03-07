require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_subdeployment) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a JMS subdeployment in a JMS module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      wlst template('puppet:///modules/orawls/providers/wls_jms_subdeployment/index.py.erb', binding)
    end

    on_create do
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_subdeployment/create.py.erb', binding)
    end

    on_modify do
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_subdeployment/modify.py.erb', binding)
    end

    on_destroy do
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_subdeployment/destroy.py.erb', binding)
    end

    def self.title_patterns
      identity = lambda {|x| x}
      [
        [
          /^(.*):(.*)$/,
          [
            [ :jmsmodule, identity ],
            [ :name     , identity ]
          ]
        ]
      ]
    end

    parameter :name
    parameter :jmsmodule
    property  :target
    property  :targettype

  private 

    def name
       self[:name]
    end

    def jmsmodule
       self[:jmsmodule]
    end

    def target
      self[:target]
    end

    def targettype
      self[:targettype]
    end

  end
end
