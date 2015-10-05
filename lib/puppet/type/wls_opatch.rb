require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_opatch) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage opatch patches on a specific middleware home.'

    ensurable

    set_command(:opatch)

    on_create  do | command_builder |
      if is_puppet_url?(source)
        fetched_source = fetch_source(source)
      else
        fetched_source = source
      end
      if is_zipfile?(fetched_source)
        extracted_source = unzip(fetched_source) 
      else
        extracted_source = "#{source}/#{patch_id}"
      end
      "apply #{extracted_source} -silent "
    end

    on_modify  do | command_builder |
      fail "Internal error. A patch is either there ot not. It cannot be modified."
    end

    on_destroy  do | command_builder |
      "rollback -id #{patch_id} -silent "
    end

    map_title_to_attributes(:name, :oracle_product_home_dir, :patch_id) do
      /^((.*):(.*))$/
    end

    parameter :name
    parameter :patch_id
    parameter :os_user
    parameter :oracle_product_home_dir
    parameter :jdk_home_dir
    parameter :source
    parameter :orainst_dir

    def opatch(command, options = {})
      provider.opatch(command)
    end

    def is_puppet_url?(url)
      url.scan(/^puppet:\/\/.*$/) != []
    end

    def is_zipfile?(file)
      Pathname(file).extname.downcase == '.zip'
    end

    def fetch_source(file)
      fail "puppet url's not (yet) supported."
    end


    def unzip(file)
      output = "/tmp/wls_opatch"
      Puppet.debug "Unzipping source #{source} to #{output}"
      `unzip -o #{file} -d '#{output}'`
      FileUtils.chmod_R(0777,output)
      "#{output}/#{patch_id}"
    end

  end


end
