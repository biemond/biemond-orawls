require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  Type.newtype(:wls_exec) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to execute a wlst command or script in the context.'

    add_title_attributes(:statement) do
      /^((\w+\/)?(.*)?)$/
    end

    def refresh
      provider.execute
    end

    parameter :domain
    parameter :name
    property  :statement
    parameter :timeout
    parameter :cwd
    parameter :logoutput
    parameter :unless
    parameter :refreshonly

  end
end
