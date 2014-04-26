require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_machine) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage machine in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { "action"=>"index","type"=>"wls_machine"}
      wlst template('puppet:///modules/orawls/providers/wls_machine/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_machine/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_machine/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_machine/destroy.py.erb', binding)
    end


    def self.title_patterns
      # possible values for /^((.*\/)?(.*)?)$/
      # default/testuser1 with this as regex outcome 
      #    default/testuser1 default/ testuser1
      # testuser1 with this as regex outcome
      #    testuser1  nil  testuser1
      identity  = lambda {|x| x}
      name      = lambda {|x| 
          if x.include? "/"
            x            # it contains a domain
          else
            'default/'+x # add the default domain
          end
        }
      optional  = lambda{ |x| 
          if x.nil?
            'default' # when not found use default
          else
            x[0..-2]  # remove the last char / from domain name
          end
        }
      [
        [
          /^((.*\/)?(.*)?)$/,
          [
            [ :name        , name     ],
            [ :domain      , optional ],
            [ :machine_name, identity ]
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

    parameter :domain
    parameter :name
    parameter :machine_name

    property  :machinetype
    property  :nmtype
    property  :listenaddress
    property  :listenport
  end
end
