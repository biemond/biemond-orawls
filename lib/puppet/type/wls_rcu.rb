module Puppet
  newtype(:wls_rcu) do
    desc 'This is the Oracle WebLogic RCU ( Repository creation utility) installer type'

    newproperty(:ensure) do
      desc 'Whether a Repository should be created.'

      newvalue(:present, :event => :rcu_installed) do
        provider.present
      end

      newvalue(:absent, :event => :rcu_absent) do
        provider.absent
      end

      aliasvalue(:create, :present)
      aliasvalue(:delete, :absent)

      def retrieve
        provider.status
      end

      def sync
        event = super()
        # rubocop:disable all
        if property = @resource.property(:enable)
          val = property.retrieve
          property.sync unless property.safe_insync?(val)
        end
        # rubocop:enable all
        event
      end

    end

    newparam(:name) do
      desc <<-EOT
        The prefix of the RCU.
      EOT
      isnamevar
    end

    newparam(:os_user) do
      desc <<-EOT
        The weblogic operating system user.
      EOT
    end

    newparam(:sys_password) do
      desc <<-EOT
        The sys password for the RCU check/install.
      EOT
    end

    newparam(:jdbc_url) do
      desc <<-EOT
        The jdbc url for the RCU check.
      EOT
    end

    newparam(:oracle_home) do
      desc <<-EOT
        The oracle_home for the WLST location.
      EOT
    end

    newparam(:check_script) do
      desc <<-EOT
        The check_script py script for the RCU Repository.
      EOT
    end

    newparam(:statement) do
      desc <<-EOT
        The RCU statement.
      EOT
    end

    newparam(:jdk_home_dir) do
      desc <<-EOT
        The jdk_home_dir.
      EOT
    end

  end
end
