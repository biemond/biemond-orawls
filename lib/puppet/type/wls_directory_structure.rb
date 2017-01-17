module Puppet
  Type.newtype(:wls_directory_structure) do
    desc 'add all the directories needed by the oracle weblogic installation'

    newparam(:name) do
      desc <<-EOT
        The title.
      EOT
      isnamevar
    end

    newproperty(:ensure) do
      desc 'Whether to do something.'

      newvalue(:present) do
        provider.configure
      end

      def retrieve
        [
          :download_dir,
          :ora_inventory_dir,
          :oracle_base_dir,
          :wls_apps_dir,
          :wls_domains_dir,
        ].map do |resourceSymbol|
          resource[resourceSymbol]
        end.map do |directory|
          if !directory.nil? && !File.exist?(directory)
            return :absent
          end
        end

        return :present
      end
    end

    newparam(:oracle_base_dir) do
      desc <<-EOT
        The oracle base folder.
      EOT
      validate do |value|
        if value.nil?
          fail ArgumentError, 'oracle_base_dir cannot be empty'
        end
      end
    end

    newparam(:ora_inventory_dir) do
      desc <<-EOT
        The oracle inventory folder.
      EOT
      validate do |value|
        if value.nil?
          fail ArgumentError, 'ora_inventory_dir cannot be empty'
        end
      end
    end

    newparam(:wls_domains_dir) do
      desc <<-EOT
        The oracle weblogic domains folder.
      EOT
    end

    newparam(:wls_apps_dir) do
      desc <<-EOT
        The oracle weblogic apps folder.
      EOT
    end

    newparam(:download_dir) do
      desc <<-EOT
        The download folder.
      EOT
      validate do |value|
        if value.nil?
          fail ArgumentError, 'download_dir cannot be empty'
        end
      end
    end

    newparam(:os_user) do
      desc <<-EOT
        The weblogic operating system user.
      EOT

      defaultto 'oracle'
    end

    newparam(:os_group) do
      desc <<-EOT
        The weblogic operating system group.
      EOT

      defaultto 'dba'
    end

  end
end
