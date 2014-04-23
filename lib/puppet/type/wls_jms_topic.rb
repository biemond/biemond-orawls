require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_topic) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a Topic in a JMS module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_jms_topic"}
      wlst template('puppet:///modules/orawls/providers/wls_jms_topic/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_topic/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_topic/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_topic/destroy.py.erb', binding)
    end

    def self.title_patterns
      identity = lambda {|x| x}
      [
        [
          /^((.*):(.*))$/,
          [
            [ :name, identity ],
            [ :jmsmodule, identity ],
            [ :topic_name, identity ]
          ]
        ],
        [
          /^([^=]+)$/,
          [
            [ :name, identity ]
          ]
        ]
      ]
    end

    parameter :name
    parameter :jmsmodule
    parameter :topic_name
    property  :distributed
    property  :jndiname
    property  :subdeployment
    property  :balancingpolicy
    property  :quota
    property  :defaulttargeting
    property  :errordestination
    property  :expirationloggingpolicy
    property  :redeliverylimit
    property  :expirationpolicy
    property  :redeliverydelay
    property  :timetodeliver
    property  :timetolive
  end
end
