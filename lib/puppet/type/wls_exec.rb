require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_exec) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a cluster in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
    end

    on_create do | command_builder |
    end

    on_modify do | command_builder |
    end

    on_destroy do | command_builder |
    end

    parameter :domain
    parameter :name
    parameter :safagent_name
    parameter :timeout
    property :servicetype
    property :persistentstore
    property :persistentstoretype
    property :target
    property :targettype

    add_title_attributes(:safagent_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
