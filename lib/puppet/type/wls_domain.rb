require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  newtype(:wls_domain) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc "This resource allows you to manage domain options"

    ensurable

    set_command(:wlst)
  

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_domain"}
      wlst template('puppet:///modules/orawls/providers/wls_domain/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      fail("create of a domain is not allowed") 
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_domain/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      fail("destroy of a domain is not allowed") 
    end

    parameter :domain
    parameter :name
    parameter :weblogic_domain_name
    property  :jta_transaction_timeout
    property  :jta_max_transactions
    property  :jpa_default_provider
    property  :security_crossdomain
    property  :log_file_min_size
    property  :log_filename
    property  :log_number_of_files_limited
    property  :log_filecount
    property  :log_rotationtype
    property  :log_rotate_logon_startup


    add_title_attributes( :weblogic_domain_name) do 
      /^((.*\/)?(.*)?)$/
    end

  end
end
