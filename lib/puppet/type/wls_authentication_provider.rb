require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_authentication_provider) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc <<-EOD
      This resource allows you to manage authentication providers in an WebLogic domain.

      Here is an example:

          wls_authentication_provider { 'domain/MyLDAPAuthenticator':
            control_flag       => 'REQUIRED',
            order              => '0',
            providerclassname  => 'weblogic.security.providers.authentication.LDAPAuthenticator',
            provider_specific  => {
              'ResultsTimeLimit' => 300,
            },
          }

      **ATTENTION:**

      After the creation or modification of a wls_authentication_provider you'll need a restart from the 
      Admin server. If you don't restart the server, the changes will not be applied. In some cases this means
      that Puppet will try to re-create the wls_authentication_provider and will produce an WLST error.

    EOD

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
    parameter :timeout

    property :control_flag
    parameter :providerclassname
    parameter :attributes
    parameter :attributesvalues
    parameter :order
    property  :provider_specific

    add_title_attributes(:authentication_provider_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
