module Puppet
  Type.newtype(:wls_domain_partition_control) do
    desc 'control a domain partition state like running,stop,restart'

    newproperty(:ensure) do
      desc 'Whether to do something.'

      newvalue(:start, :event => :domain_partition_running) do
        unless :refreshonly == true
          provider.start
        end
      end

      newvalue(:stop, :event => :domain_partition_running) do
        unless :refreshonly == true
          provider.stop
        end
      end

      aliasvalue(:running, :start)
      aliasvalue(:abort, :stop)

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
        The title.
      EOT
      isnamevar
    end

    newparam(:domain_partition) do
      desc <<-EOT
        The domain partition name.
      EOT
    end

    newparam(:os_user) do
      desc <<-EOT
        The weblogic operating system user.
      EOT
    end

    newparam(:middleware_home_dir) do
      desc <<-EOT
        The middleware home folder.
      EOT
    end

    newparam(:weblogic_user) do
      desc <<-EOT
        The weblogic user.
      EOT
    end

    newparam(:weblogic_password) do
      desc <<-EOT
        The weblogic user password.
      EOT
    end

    newparam(:adminserver_address) do
      desc <<-EOT
        The adminserver address.
      EOT
    end

    newparam(:adminserver_port) do
      desc <<-EOT
        The adminserver port.
      EOT
    end

    newparam(:refreshonly) do
      desc <<-EOT
        The command should only be run as a
        refresh mechanism for when a dependent object is changed.
      EOT

      newvalues(:true, :false)

      defaultto :false
    end

    def refresh
      Puppet.info 'wls_domain_partition_control refresh'
      provider.restart
    end

  end
end
