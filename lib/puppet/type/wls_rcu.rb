module Puppet
  newtype(:wls_rcu) do
    desc "This is the Oracle WebLogic RCU ( Repository creation utility) installer type "

    newproperty(:ensure) do
      desc "Whether a Repository should be created."

      newvalue(:present, :event => :rcu_installed, :invalidate_refreshes => true) do
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

        if property = @resource.property(:enable)
          val = property.retrieve
          property.sync unless property.safe_insync?(val)
        end

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

    newparam(:oracle_home) do
      desc <<-EOT
        The oracle database home folder.
      EOT
    end

    newparam(:sys_password) do
      desc <<-EOT
        The sys password for the RCU check/install.
      EOT
    end

    newparam(:db_server) do
      desc <<-EOT
        The database server for the RCU check/install.
      EOT
    end

    newparam(:db_service) do
      desc <<-EOT
        The database service for the RCU check/install.
      EOT
    end

    newparam(:statement) do
      desc <<-EOT
        The RCU statement.
      EOT
    end

  end
end