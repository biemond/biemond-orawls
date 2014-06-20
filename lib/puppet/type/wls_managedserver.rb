module Puppet
  newtype(:wls_managedserver) do
    desc "control a managed server or cluster state like running,stop,restart"

    newproperty(:ensure) do
      desc "Whether to do something."

      newvalue(:start, :event => :managedserver_running) do
        unless :refreshonly == true
          provider.start
        end 
      end

      newvalue(:stop, :event => :managedserver_running) do
        unless :refreshonly == true
          provider.stop
        end 
      end

      aliasvalue(:running, :start)
      aliasvalue(:abort  , :stop)

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
        The title.
      EOT
      isnamevar
    end

    newparam(:target) do
      desc <<-EOT
        The weblogic type.
      EOT
    end

    newparam(:server_name) do
      desc <<-EOT
        The adminserver name.
      EOT
    end

    newparam(:domain_name) do
      desc <<-EOT
        The weblogic domain name.
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
      Puppet.info "wls_managedserver refresh"
      provider.restart
    end

  end
end