require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_server) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage server in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      wlst template('puppet:///modules/orawls/providers/wls_server/index.py.erb', binding)
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_server/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_server/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_server/destroy.py.erb', binding)
    end

    parameter :name
    property  :ssllistenport
    property  :sslenabled
    property  :listenaddress
    property  :listenport
    property  :machine
    property  :classpath
    property  :arguments
    property  :logfilename
    property  :sslhostnameverificationignored
    property  :jsseenabled

  private 

    def jsseenabled
      self[:jsseenabled]
    end

    def ssllistenport
      self[:ssllistenport]
    end

    def sslenabled
      self[:sslenabled]
    end

    def listenaddress
      self[:listenaddress]
    end

    def listenport
      self[:listenport]
    end

    def machine
      self[:machine]
    end

    def classpath
      self[:classpath]
    end

    def arguments
      self[:arguments]
    end

    def logfilename
      self[:logfilename]
    end

    def sslhostnameverificationignored
      self[:sslhostnameverificationignored]
    end

  end
end
