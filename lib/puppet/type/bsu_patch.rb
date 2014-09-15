module Puppet
  newtype(:bsu_patch) do
    desc 'This is the WebLogic Patch process called BSU'

    newproperty(:ensure) do
      desc 'Whether a patch should be applied.'

      newvalue(:present, :event => :bsu_installed) do
        provider.present
      end

      newvalue(:absent, :event => :bsu_absent) do
        provider.absent
      end

      aliasvalue(:installed, :present)
      aliasvalue(:purged, :absent)

      def retrieve
        provider.status
      end

      def sync
        event = super()

        if property == @resource.property(:enable)
          val = property.retrieve
          property.sync unless property.safe_insync?(val)
        end

        event
      end

    end

    newparam(:name) do
      desc <<-EOT
        The name of the BSU WebLogic Patch.
      EOT
      isnamevar
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

    newparam(:jdk_home_dir) do
      desc <<-EOT
        The JDK home folder.
      EOT
    end

    newparam(:weblogic_home_dir) do
      desc <<-EOT
        The weblogic home home folder.
      EOT
    end

    newparam(:patch_download_dir) do
      desc <<-EOT
        The BSU pathc download dir folder.
      EOT
    end

  end
end
