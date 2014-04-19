require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_quota) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a Quota in a JMS module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_jms_quota"}
      wlst template('puppet:///modules/orawls/providers/wls_jms_quota/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create"
      template('puppet:///modules/orawls/providers/wls_jms_quota/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify"
      template('puppet:///modules/orawls/providers/wls_jms_quota/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy"
      template('puppet:///modules/orawls/providers/wls_jms_quota/destroy.py.erb', binding)
    end

    def self.title_patterns
      identity = lambda {|x| x}
      [
        [
          /^((.*):(.*))$/,
          [
            [ :name, identity ],
            [ :jmsmodule, identity ],
            [ :quota_name, identity ]
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
    parameter :quota_name
    property  :bytesmaximum
    property  :messagesmaximum
    property  :policy
    property  :shared

  end
end
