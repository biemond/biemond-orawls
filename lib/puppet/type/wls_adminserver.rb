module Puppet
  Type.newtype(:wls_adminserver) do
    desc 'control the adminserver state like running,stop,restart'

    newproperty(:ensure) do
      desc 'Whether to do something.'

      newvalue(:start, :event => :adminserver_running) do
        unless :refreshonly == true
          provider.start
        end
      end

      newvalue(:stop, :event => :adminserver_stop) do
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

    newparam(:server_name) do
      desc <<-EOT
        The adminserver name.
      EOT
    end

    newparam(:ohs_standalone_server) do
      desc <<-EOT
        Flag to determinate if the server is a OHS standalone server.
      EOT

      newvalues(:true, :false)

      defaultto :false
    end

    newparam(:domain_name) do
      desc <<-EOT
        The weblogic domain name.
      EOT
    end

    newparam(:domain_path) do
      desc <<-EOT
        The full domain path.
      EOT
    end

    newparam(:os_user) do
      desc <<-EOT
        The weblogic operating system user.
      EOT
    end

    newparam(:weblogic_home_dir) do
      desc <<-EOT
        The weblogic home folder.
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

    newparam(:jdk_home_dir) do
      desc <<-EOT
        The jdk home dir.
      EOT
    end

    newparam(:nodemanager_address) do
      desc <<-EOT
        The nodemanager address.
      EOT
    end

    newparam(:nodemanager_port) do
      desc <<-EOT
        The nodemanager port.
      EOT
    end

    newparam(:nodemanager_secure_listener) do
      desc <<-EOT
        The nodemanager secure listener true or false.
      EOT

      newvalues(:true, :false)

      defaultto :true
    end

    newparam(:jsse_enabled) do
      desc <<-EOT
        The jsse enabled.
      EOT
      newvalues(:true, :false)

      defaultto :false
    end

    newparam(:custom_trust) do
      desc <<-EOT
        The custom trust enabled.
      EOT
      newvalues(:true, :false)

      defaultto :false
    end

    newparam(:trust_keystore_file) do
      desc <<-EOT
        The trust keystore full path.
      EOT
    end

    newparam(:trust_keystore_passphrase) do
      desc <<-EOT
        The trust keystore password.
      EOT

    end

    newparam(:extra_arguments) do
      desc <<-EOT
        The extra java argument like -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1.
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
      Puppet.info 'wls_adminserver refresh'
      provider.restart
    end

  end
end
